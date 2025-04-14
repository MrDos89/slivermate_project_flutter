import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:slivermate_project_flutter/vo/clubVo.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:slivermate_project_flutter/vo/announceVo.dart';
import 'package:slivermate_project_flutter/vo/purchaseVo.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:slivermate_project_flutter/pages/paymentPage.dart';

class MeetingSchedulePage extends StatefulWidget {
  final UserVo currentUser;

  const MeetingSchedulePage({Key? key, required this.currentUser})
    : super(key: key);

  @override
  State<MeetingSchedulePage> createState() => _MeetingSchedulePageState();
}

class _MeetingSchedulePageState extends State<MeetingSchedulePage> {
  bool isLoading = false;
  List<ClubVo> allClubs = [];
  List<UserVo> familyMembers = [];
  List<ClubVo> joinedClubs = [];
  Map<String, dynamic>? purchaseData;
  List<AnnounceVo> allAnnouncements = [];
  Set<DateTime> markedDates = {}; // ✅ 달력에 표시할 날짜

  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");
  static final Dio dio = Dio();

  late PersistCookieJar cookieJar;
  late String allClubsUrl;
  late String userGroupUrl;
  late String joinedClubsUrl;
  late String purchaseUrl;
  late String announcementUrl;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<AnnounceVo> selectedSchedules = [];

  @override
  void initState() {
    super.initState();
    allClubsUrl = "http://$ec2IpAddress:$ec2Port/api/club";
    userGroupUrl = "http://$ec2IpAddress:$ec2Port/api/usergroup";
    joinedClubsUrl = "http://$ec2IpAddress:$ec2Port/api/club";
    purchaseUrl = "http://$ec2IpAddress:$ec2Port/api/purchase";
    announcementUrl = "http://$ec2IpAddress:$ec2Port/api/announcement";

    _initDio().then((_) => _fetchAllData());
  }

  Future<void> _initDio() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      storage: FileStorage("${appDocDir.path}/.cookies/"),
    );
    dio.interceptors.add(CookieManager(cookieJar));
  }

  Future<void> _fetchAllData() async {
    setState(() => isLoading = true);
    try {
      await _fetchPurchaseData();
      await _fetchAllClubs();
      await _fetchFamilyMembers();
      await _fetchJoinedClubs();
      await _fetchAnnouncements();
    } catch (e) {
      debugPrint("오류 발생: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchPurchaseData() async {
    try {
      final response = await dio.get(
        purchaseUrl,
        queryParameters: {"uid": widget.currentUser.uid},
      );
      if (response.statusCode == 200) {
        purchaseData = response.data as Map<String, dynamic>?;
      }
    } catch (e) {
      debugPrint("결제 정보 호출 실패 (GET): $e");
    }
  }

  Future<void> _fetchAllClubs() async {
    try {
      final response = await dio.get(allClubsUrl);
      if (response.statusCode == 200 && response.data is List) {
        final list = response.data as List;
        allClubs = list.map((e) => ClubVo.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("전체 모임 목록 호출 실패: $e");
    }
  }

  Future<void> _fetchFamilyMembers() async {
    if (widget.currentUser.groupId == 0) return;
    try {
      final response = await dio.get(
        "$userGroupUrl/${widget.currentUser.groupId}",
      );
      if (response.statusCode == 200 && response.data is List) {
        final list = response.data as List;
        familyMembers = list.map((e) => UserVo.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("가족/그룹 정보 호출 실패: $e");
    }
  }

  Future<void> _fetchJoinedClubs() async {
    try {
      final response = await dio.get(
        "$joinedClubsUrl/${widget.currentUser.uid}/joined",
      );
      if (response.statusCode == 200 && response.data is List) {
        final list = response.data as List;
        joinedClubs = list.map((e) => ClubVo.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("가입한 모임 목록 호출 실패: $e");
    }
  }

  Future<void> _fetchAnnouncements() async {
    try {
      final response = await dio.get(announcementUrl);
      if (response.statusCode == 200 && response.data is List) {
        final list = response.data as List;
        allAnnouncements = list.map((e) => AnnounceVo.fromJson(e)).toList();
        // ✅ 참석한 일정만 달력에 표시될 날짜로 저장
        markedDates =
            allAnnouncements
                .where(
                  (a) =>
                      a.memberList.contains(widget.currentUser.uid.toString()),
                )
                .map((a) => DateTime.parse(a.date))
                .toSet();
      }
    } catch (e) {
      debugPrint("공지/일정 정보 호출 실패: $e");
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      selectedSchedules =
          allAnnouncements.where((a) {
            return DateTime.parse(a.date).year == selectedDay.year &&
                DateTime.parse(a.date).month == selectedDay.month &&
                DateTime.parse(a.date).day == selectedDay.day &&
                a.memberList.contains(widget.currentUser.uid.toString());
          }).toList();
    });
  }

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "모임 일정 페이지"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCalendarSection(),
              const SizedBox(height: 20),
              if (_selectedDay != null) _buildScheduleList(),
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "일정을 확인해 주세요",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: _buildTableCalendar(),
        ),
      ],
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: _onDaySelected,
      onFormatChanged: _onFormatChanged,
      headerStyle: const HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
      ),
      calendarStyle: CalendarStyle(
        markerDecoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        markersMaxCount: 1,
        markersAlignment: Alignment.bottomCenter,
        todayDecoration: const BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          if (markedDates.any((d) => isSameDay(d, day))) {
            return const Positioned(
              bottom: 1,
              child: Icon(Icons.circle, size: 8, color: Colors.green),
            );
          }
          return null;
        },
      ),
    );
  }

  Widget _buildScheduleList() {
    if (selectedSchedules.isEmpty) {
      return const Text("선택한 날짜에 일정이 없습니다.");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          selectedSchedules.map((schedule) {
            final bool isPaid =
                purchaseData != null && purchaseData!["is_paid"] == true;
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: Text(schedule.title),
                    subtitle: Text(
                      "${schedule.date} | ${schedule.time}\n${schedule.location}",
                    ),
                    trailing: Text(schedule.meetingPrice),
                    isThreeLine: true,
                  ),
                  if (!isPaid)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0, right: 12.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            "결제하기",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
