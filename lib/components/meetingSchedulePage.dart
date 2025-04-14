import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:slivermate_project_flutter/vo/clubVo.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:slivermate_project_flutter/vo/announceVo.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
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
  List<ClubVo> allClubs = [];
  List<UserVo> familyMembers = [];
  List<ClubVo> joinedClubs = [];
  Map<String, dynamic>? purchaseData;

  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");
  static final Dio dio = Dio();

  late PersistCookieJar cookieJar;
  late String allClubsUrl;
  late String userGroupUrl;
  late String joinedClubsUrl;
  late String purchaseUrl;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<AnnounceVo>> dummySchedules = {
    DateTime(2025, 4, 10): [
      AnnounceVo(
        title: "4월 정기 등산",
        date: "2025.04.10 (목)",
        time: "오전 9시",
        location: "북한산 입구",
        description: "서울 등산 동호회 4월 정기 모임입니다.",
        meetingPrice: "5,000원",
        attendingCount: 12,
        type: 2,
        updDate: DateTime(2025, 4, 1),
      ),
    ],
    DateTime(2025, 4, 14): [
      AnnounceVo(
        title: "스터디 모임",
        date: "2025.04.14 (월)",
        time: "오후 7시",
        location: "강남역 3번 출구",
        description: "Flutter 스터디 모임입니다.",
        meetingPrice: "0원",
        attendingCount: 8,
        type: 1,
        updDate: DateTime(2025, 4, 7),
      ),
    ],
    DateTime(2025, 4, 18): [
      AnnounceVo(
        title: "영화 관람",
        date: "2025.04.18 (금)",
        time: "오후 2시",
        location: "CGV 용산",
        description: "가족과 함께하는 영화 관람 모임.",
        meetingPrice: "12,000원",
        attendingCount: 5,
        type: 2,
        updDate: DateTime(2025, 4, 9),
      ),
    ],
    DateTime(2025, 4, 20): [
      AnnounceVo(
        title: "요가 클래스",
        date: "2025.04.20 (일)",
        time: "오전 10시",
        location: "동네 체육관",
        description: "어르신을 위한 요가 클래스.",
        meetingPrice: "3,000원",
        attendingCount: 10,
        type: 1,
        updDate: DateTime(2025, 4, 11),
      ),
    ],
    DateTime(2025, 4, 22): [
      AnnounceVo(
        title: "가족 나들이",
        date: "2025.04.22 (화)",
        time: "오전 11시",
        location: "서울숲",
        description: "가족 봄 소풍입니다.",
        meetingPrice: "도시락 지참",
        attendingCount: 6,
        type: 2,
        updDate: DateTime(2025, 4, 15),
      ),
    ],
  };

  List<AnnounceVo> selectedSchedules = [];

  @override
  void initState() {
    super.initState();
    allClubsUrl = "http://$ec2IpAddress:$ec2Port/api/club";
    userGroupUrl = "http://$ec2IpAddress:$ec2Port/api/usergroup";
    joinedClubsUrl = "http://$ec2IpAddress:$ec2Port/api/club";
    purchaseUrl = "http://$ec2IpAddress:$ec2Port/api/purchase";

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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      selectedSchedules =
          dummySchedules.entries
              .firstWhere(
                (entry) => isSameDay(entry.key, selectedDay),
                orElse: () => MapEntry(DateTime(2000), <AnnounceVo>[]),
              )
              .value;
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

  Widget _buildScheduleList() {
    if (selectedSchedules.isEmpty) {
      return const Text("선택한 날짜에 일정이 없습니다.");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          selectedSchedules.map((schedule) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(schedule.title),
                subtitle: Text(
                  "${schedule.date} | ${schedule.time}\n${schedule.location}",
                ),
                trailing: Text(schedule.meetingPrice),
                isThreeLine: true,
              ),
            );
          }).toList(),
    );
  }
}
