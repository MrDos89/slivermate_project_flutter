import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:slivermate_project_flutter/vo/clubVo.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

// 달력 패키지 (pubspec.yaml에 table_calendar: ^3.0.8 등 버전에 맞게 추가)
import 'package:table_calendar/table_calendar.dart';

class MeetingSchedulePage extends StatefulWidget {
  final UserVo currentUser;

  const MeetingSchedulePage({Key? key, required this.currentUser})
    : super(key: key);

  @override
  State<MeetingSchedulePage> createState() => _MeetingSchedulePageState();
}

class _MeetingSchedulePageState extends State<MeetingSchedulePage> {
  bool isLoading = false;

  // (1) 전체 모임 목록
  List<ClubVo> allClubs = [];

  // (2) currentUser -> widget.currentUser에 이미 있음

  // (3) 가족/그룹 정보
  List<UserVo> familyMembers = [];

  // (4) 내가(혹은 부모님이) 가입한 모임
  List<ClubVo> joinedClubs = [];

  // (5) 결제 정보 (GET 방식)
  Map<String, dynamic>? purchaseData;

  // .env에서 가져올 IP/PORT
  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");
  static final Dio dio = Dio();

  late PersistCookieJar cookieJar;

  // (1) 전체 모임 목록: GET /api/club
  late String allClubsUrl;
  // (3) 가족/그룹 정보: GET /api/usergroup/{groupId}
  late String userGroupUrl;
  // (4) 가입 모임 목록: GET /api/club/{uid}/joined
  late String joinedClubsUrl;
  // (5) 결제 정보 (GET): GET /api/purchase?uid=xxx
  late String purchaseUrl;

  // 달력 관련 상태
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    // 주소 세팅
    allClubsUrl = "http://$ec2IpAddress:$ec2Port/api/club";
    userGroupUrl = "http://$ec2IpAddress:$ec2Port/api/usergroup";
    joinedClubsUrl = "http://$ec2IpAddress:$ec2Port/api/club";
    purchaseUrl = "http://$ec2IpAddress:$ec2Port/api/purchase";

    // Dio 초기화 후, 필요한 데이터 한 번에 호출
    _initDio().then((_) {
      _fetchAllData();
    });
  }

  /// Dio 및 쿠키 매니저 설정
  Future<void> _initDio() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      storage: FileStorage("${appDocDir.path}/.cookies/"),
    );
    dio.interceptors.add(CookieManager(cookieJar));
  }

  /// 한 번에 필요한 API 호출
  Future<void> _fetchAllData() async {
    setState(() => isLoading = true);
    try {
      // A. 결제 정보 (GET 방식)
      await _fetchPurchaseData();
      // B. 전체 모임 목록
      await _fetchAllClubs();
      // C. 가족/그룹 정보
      await _fetchFamilyMembers();
      // D. 가입한 모임 목록
      await _fetchJoinedClubs();
      // (E) currentUser는 이미 widget.currentUser 에 있음
    } catch (e) {
      debugPrint("오류 발생: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// (5) 결제 정보 (GET)
  Future<void> _fetchPurchaseData() async {
    try {
      // GET /api/purchase?uid=...
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

  /// (1) 전체 모임 목록
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

  /// (3) 가족/그룹 정보
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

  /// (4) 내가(혹은 부모님이) 가입한 모임
  Future<void> _fetchJoinedClubs() async {
    try {
      int targetUid = widget.currentUser.uid;
      // 필요 시 자녀 → 부모 uid 변환 로직 추가 가능
      final response = await dio.get("$joinedClubsUrl/$targetUid/joined");
      if (response.statusCode == 200 && response.data is List) {
        final list = response.data as List;
        joinedClubs = list.map((e) => ClubVo.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("가입한 모임 목록 호출 실패: $e");
    }
  }

  /// 달력에서 날짜 선택 시 (예시)
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    // TODO: 특정 날짜를 클릭했을 때 모임 일정 필터하기
    debugPrint("날짜 $_selectedDay 선택 - 모임 일정 필터 (예시)");
  }

  /// 달력의 포맷 변경 시 (주간 ↔ 월간 등)
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
              // 달력만 표시
              _buildCalendarSection(),

              const SizedBox(height: 20),

              // 아래는 로딩 인디케이터만 표시 (데이터는 UI에서 안 보여줌)
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  /// 실제 달력 UI
  Widget _buildCalendarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "달력을 표시해 주세요 (table_calendar 예시)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // 여기서 table_calendar를 사용
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

      // 달력 상단 헤더 스타일
      headerStyle: const HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
      ),

      // 달력 내부 UI 스타일
      calendarStyle: const CalendarStyle(
        markerDecoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        weekendTextStyle: TextStyle(color: Colors.red),
        selectedDecoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
