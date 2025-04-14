import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/clubVo.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ClassPage extends StatefulWidget {
  final UserVo currentUser; // 로그인한 유저 정보
  const ClassPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  bool isLoading = false;

  // (1) 가입한 동아리 목록
  List<ClubVo> joinedClubs = [];

  // (2) 모임장(Host) 동아리 목록
  List<ClubVo> hostClubs = [];

  // (3) 가족 구성원 목록
  List<UserVo> familyMembers = [];

  // .env에서 가져올 IP와 PORT
  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");
  static final Dio dio = Dio();

  // API Endpoints
  late String familyUrl; // "/api/usergroup/{groupId}"
  late String joinedClubsUrl; // "/api/club/{uid}/joined"
  late String allClubsUrl; // "/api/club" (전체 목록)

  @override
  void initState() {
    super.initState();
    // familyUrl: 가족 정보
    familyUrl = "http://$ec2IpAddress:$ec2Port/api/usergroup";
    // joinedClubsUrl: "/api/club" 뒤에 "{uid}/joined" 붙여 쓰기
    joinedClubsUrl = "http://$ec2IpAddress:$ec2Port/api/club";
    // allClubsUrl: 전체 모임 목록
    allClubsUrl = "http://$ec2IpAddress:$ec2Port/api/club";

    _fetchFamilyMembers();
    _fetchJoinedClubs();
    _fetchHostClubsByFiltering();
  }

  /// (A) 가족 구성원 불러오기
  Future<void> _fetchFamilyMembers() async {
    final int groupId = widget.currentUser.groupId;
    if (groupId == 0) return; // groupId가 0이면 처리X

    setState(() => isLoading = true);
    try {
      final response = await dio.get("$familyUrl/$groupId");
      if (response.statusCode == 200 && response.data is List) {
        final dataList = response.data as List;
        final parsed = dataList.map((e) => UserVo.fromJson(e)).toList();

        final myType = widget.currentUser.userType;
        final myUid = widget.currentUser.uid;

        if (myType == 1) {
          // (부모) => userType=2만 familyMembers에
          familyMembers = parsed.where((u) => u.userType == 2).toList();
        } else {
          // (자녀) => (부모=userType=1) 포함, 나(uid) 제외
          familyMembers = parsed.where((u) => u.uid != myUid).toList();
        }
      }
    } catch (e) {
      debugPrint("가족 구성원 호출 중 오류 발생: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// (B) (내가 or 부모님이) 가입한 모임 불러오기
  Future<void> _fetchJoinedClubs() async {
    setState(() => isLoading = true);
    try {
      final bool isParent = (widget.currentUser.userType == 1);
      int targetUid = widget.currentUser.uid;

      // 자녀인 경우 → 부모님 uid로 교체
      if (!isParent) {
        final parent = familyMembers.firstWhere(
          (u) => u.userType == 1,
          orElse: () => widget.currentUser,
        );
        targetUid = parent.uid;
      }

      // 예: GET /api/club/{targetUid}/joined
      final response = await dio.get("$joinedClubsUrl/$targetUid/joined");
      if (response.statusCode == 200 && response.data is List) {
        final dataList = response.data as List;
        joinedClubs = dataList.map((e) => ClubVo.fromJson(e)).toList();
        debugPrint("joinedClubs: $joinedClubs");
      }
    } catch (e) {
      debugPrint("모임 목록 호출 중 오류 발생 (joined): $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// (C) 모임장(Host) 동아리 목록 (별도 API가 없어서 전체 모임 목록에서 필터)
  Future<void> _fetchHostClubsByFiltering() async {
    setState(() => isLoading = true);
    try {
      final bool isParent = (widget.currentUser.userType == 1);
      int hostUid = widget.currentUser.uid;

      // 자녀 → 부모 uid
      if (!isParent) {
        final parent = familyMembers.firstWhere(
          (u) => u.userType == 1,
          orElse: () => widget.currentUser,
        );
        hostUid = parent.uid;
      }

      // GET 전체 목록 → 필터링
      final response = await dio.get(allClubsUrl);
      if (response.statusCode == 200 && response.data is List) {
        final dataList = response.data as List;
        final allClubs = dataList.map((e) => ClubVo.fromJson(e)).toList();

        // 필터: clubUserId == hostUid
        hostClubs =
            allClubs
                .where((c) => c.clubUserId.toString() == hostUid.toString())
                .toList();
      }
    } catch (e) {
      debugPrint("모임장 동아리 목록 호출 중 오류 발생: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "내가 가입한 모임"),
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // (1) 호스트(모임장) 동아리 목록
          _buildHostClubSection(),

          const SizedBox(height: 24),

          // (2) 내가(혹은 부모님이) 가입한 동아리 목록
          _buildJoinedClubsSection(),
        ],
      ),
    );
  }

  /// 호스트(모임장) 동아리 목록 섹션
  Widget _buildHostClubSection() {
    final bool isParent = (widget.currentUser.userType == 1);
    final title = isParent ? "내가 모임장인 동아리 목록" : "부모님이 모임장인 동아리 목록";

    if (hostClubs.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            isParent ? "내가 모임장인 동아리가 없습니다." : "부모님이 모임장인 동아리가 없습니다.",
            style: const TextStyle(fontSize: 14),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: hostClubs.length,
            itemBuilder: (context, index) {
              final c = hostClubs[index];
              return _buildClubItem(c);
            },
          ),
        ],
      );
    }
  }

  /// 가입한 동아리 목록 섹션
  Widget _buildJoinedClubsSection() {
    final bool isParent = (widget.currentUser.userType == 1);
    final title = isParent ? "내가 가입한 동아리 목록" : "부모님이 가입한 동아리 목록";

    if (joinedClubs.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("가입된 동아리가 없습니다.", style: TextStyle(fontSize: 14)),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: joinedClubs.length,
            itemBuilder: (context, index) {
              final c = joinedClubs[index];
              return _buildClubItem(c);
            },
          ),
        ],
      );
    }
  }

  /// 개별 모임 아이템
  Widget _buildClubItem(ClubVo club) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // TODO: 상세 페이지 이동
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 썸네일
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                  image:
                      club.clubThumbnail.isNotEmpty
                          ? DecorationImage(
                            image: NetworkImage(club.clubThumbnail),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
              ),
              const SizedBox(width: 12),
              // 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      club.clubName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text("멤버: ${club.clubMemberNumber}/${club.clubMemberMax}"),
                    Text(
                      "가입일: "
                      "${club.clubRegisterDate.year}-"
                      "${club.clubRegisterDate.month.toString().padLeft(2, '0')}-"
                      "${club.clubRegisterDate.day.toString().padLeft(2, '0')}",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
