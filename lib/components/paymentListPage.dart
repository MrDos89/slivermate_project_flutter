import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:slivermate_project_flutter/vo/announceVo.dart';
import 'package:slivermate_project_flutter/vo/purchaseVo.dart';
import 'package:slivermate_project_flutter/vo/clubVo.dart';
import 'package:slivermate_project_flutter/pages/paymentPage.dart';

class PaymentListPage extends StatefulWidget {
  final UserVo currentUser;
  const PaymentListPage({Key? key, required this.currentUser})
    : super(key: key);

  @override
  State<PaymentListPage> createState() => _PaymentListPageState();
}

class _PaymentListPageState extends State<PaymentListPage> {
  // List to store fetched announcements (real data; only those where the current user's UID is in the memberList)
  List<AnnounceVo> _announcements = [];
  // List to store purchase records for the current user (from sliver_purchase)
  List<dynamic> _purchaseRecords = [];
  // List of clubs (used to get a thumbnail from the club's data)
  List<ClubVo> _clubs = [];

  bool _isLoading = false;
  Map<String, dynamic>? purchaseData; // (if needed for extra info)

  late PersistCookieJar cookieJar;
  static final Dio dio = Dio();

  // API endpoints – adjust these URLs as needed (they're derived from your .env settings)
  late String announcementUrl; // GET /api/announcement
  late String purchaseUrl; // GET /api/purchase?uid=xxx (returns a list)
  late String clubUrl; // GET /api/club

  @override
  void initState() {
    super.initState();
    announcementUrl =
        "http://${dotenv.get("EC2_IP_ADDRESS")}:${dotenv.get("EC2_PORT")}/api/announcement";
    purchaseUrl =
        "http://${dotenv.get("EC2_IP_ADDRESS")}:${dotenv.get("EC2_PORT")}/api/purchase";
    clubUrl =
        "http://${dotenv.get("EC2_IP_ADDRESS")}:${dotenv.get("EC2_PORT")}/api/club";
    _initDioAndFetchData();
  }

  Future<void> _initDioAndFetchData() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      storage: FileStorage("${appDocDir.path}/.cookies/"),
    );
    dio.interceptors.add(CookieManager(cookieJar));
    await _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    setState(() => _isLoading = true);
    try {
      await Future.wait([
        _fetchPurchaseRecords(),
        _fetchAnnouncementData(),
        _fetchClubs(),
      ]);
      // Optionally, you can process the fetched data here if needed.
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// (1) Fetch purchase records for the current user via GET.
  Future<void> _fetchPurchaseRecords() async {
    try {
      final response = await dio.get(
        purchaseUrl,
        queryParameters: {"uid": widget.currentUser.uid},
      );
      if (response.statusCode == 200 && response.data is List) {
        _purchaseRecords = response.data as List;
      }
    } catch (e) {
      debugPrint("Purchase records fetch error: $e");
    }
  }

  /// (2) Fetch announcements (only those where the current user's UID is contained in member_list)
  Future<void> _fetchAnnouncementData() async {
    try {
      final response = await dio.get(announcementUrl);
      if (response.statusCode == 200 && response.data is List) {
        final list = response.data as List;
        _announcements =
            list
                .map((e) => AnnounceVo.fromJson(e))
                .where(
                  (ann) => ann.memberList.contains(
                    widget.currentUser.uid.toString(),
                  ),
                )
                .toList();
      }
    } catch (e) {
      debugPrint("Announcement data fetch error: $e");
    }
  }

  /// (3) Fetch all clubs (used to get the thumbnail for an announcement via club_id)
  Future<void> _fetchClubs() async {
    try {
      final response = await dio.get(clubUrl);
      if (response.statusCode == 200 && response.data is List) {
        final list = response.data as List;
        _clubs = list.map((e) => ClubVo.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Clubs fetch error: $e");
    }
  }

  /// Helper to get purchase info for a given announcement.
  Map<String, dynamic>? _getPurchaseInfoForAnnouncement(AnnounceVo ann) {
    try {
      return _purchaseRecords.firstWhere(
        (record) =>
            record["announce_id"].toString() ==
                ann.toJson()['announce_id'].toString() &&
            record["uid"].toString() == widget.currentUser.uid.toString(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Helper to format a date string (expects ISO8601 parsable string) to yyyy-MM-dd.
  String _formattedDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      final dt = DateTime.parse(dateStr);
      return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateStr;
    }
  }

  /// Build the UI for each announcement (payment item) card.
  Widget _buildAnnouncementCard(AnnounceVo ann) {
    // Retrieve purchase info for this announcement.
    final purchaseInfo = _getPurchaseInfoForAnnouncement(ann);
    final bool isPaid =
        purchaseInfo != null && (purchaseInfo["is_paid"] ?? false);
    final String? paidAt =
        purchaseInfo != null ? purchaseInfo["purchase_date"] : null;

    // Determine thumbnail from club data (without modifying AnnounceVo).
    String thumbnail = "";
    final annJson = ann.toJson();
    if (annJson.containsKey('club_id') && annJson['club_id'] != null) {
      try {
        // Find the club where clubId matches the announcement's club_id
        final club = _clubs.firstWhere((c) => c.clubId == annJson['club_id']);
        if (club.clubThumbnail.isNotEmpty) {
          thumbnail = club.clubThumbnail;
        }
      } catch (e) {
        debugPrint("No matching club found for announcement: $e");
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Left: Thumbnail image (from club if available)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                thumbnail,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder:
                    (ctx, err, stack) =>
                        Container(width: 80, height: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            // Right: Announcement details (meeting information)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ann.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ann.description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${ann.location} / ${ann.time}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "회비: ${ann.meetingPrice}원",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  if (isPaid)
                    Text(
                      "결제 완료 (${_formattedDate(paidAt)})",
                      style: const TextStyle(fontSize: 13, color: Colors.green),
                    )
                  else
                    Text(
                      "참석일: ${_formattedDate(ann.date)} (결제 필요)",
                      style: const TextStyle(fontSize: 13, color: Colors.red),
                    ),
                ],
              ),
            ),
            if (!isPaid) ...[
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Navigate to PaymentPage, passing announcement details.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => PaymentPage(
                            meetingTitle: ann.title,
                            meetingDesc: ann.description,
                            meetingFee: int.tryParse(ann.meetingPrice) ?? 0,
                            meetingTime: "${ann.location} / ${ann.time}",
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("결제하기"),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: const HeaderPage(pageTitle: "결제 리스트", showBackButton: true),
        body:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: _announcements.length,
                  itemBuilder: (context, index) {
                    final ann = _announcements[index];
                    return _buildAnnouncementCard(ann);
                  },
                ),
      ),
    );
  }
}
