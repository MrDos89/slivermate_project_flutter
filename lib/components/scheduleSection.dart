import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/vo/announceVo.dart';
import 'package:slivermate_project_flutter/pages/announcementListPage.dart';
import 'package:slivermate_project_flutter/pages/addMeetingPage.dart';
import 'package:slivermate_project_flutter/components/scheduleCalendar.dart';
import 'package:dio/dio.dart';

class ScheduleSection extends StatefulWidget {
  final int clubId;
  final int clubLeaderId;
  final int currentUserId;

  const ScheduleSection({
    super.key,
    required this.clubId,
    required this.clubLeaderId,
    required this.currentUserId,
  });

  @override
  State<ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends State<ScheduleSection> {
  List<AnnounceVo> clubSchedules = [];
  Map<DateTime, List<AnnounceVo>> scheduleMap = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showSchedule = false;

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  Future<void> fetchSchedules() async {
    final dio = Dio(BaseOptions(baseUrl: 'http://43.201.50.194:18090/api'));
    try {
      final response = await dio.get('/announcement/club/${widget.clubId}');
      final data = response.data as List;
      clubSchedules = data.map((json) => AnnounceVo.fromJson(json)).toList();

      scheduleMap.clear();
      for (var item in clubSchedules) {
        if (!item.isMeeting) continue;
        final parts = item.date.split('.');
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2].split(' ')[0]);
        final date = DateTime.utc(year, month, day);
        scheduleMap.putIfAbsent(date, () => []).add(item);
      }

      setState(() {});
    } catch (e) {
      debugPrint('❌ 일정 불러오기 실패: $e');
    }
  }

  void _showScheduleDialog({
    required DateTime selectedDay,
    required List<AnnounceVo> events,
  }) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${selectedDay.month}월 ${selectedDay.day}일 일정"),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: events.map((event) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("시간: ${event.time}"),
                      Text("지역:  ${event.location}"),
                      Text("회비: ${event.meetingPrice}"),
                      Text(event.description),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text("참석 ${event.attendingCount}명"),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setModalState(() {
                                final updated = AnnounceVo(
                                  title: event.title,
                                  date: event.date,
                                  time: event.time,
                                  location: event.location,
                                  description: event.description,
                                  meetingPrice: event.meetingPrice,
                                  memberList: event.memberList,
                                  attendingCount: event.attendingCount + 1,
                                  type: event.type,
                                  updDate: event.updDate,
                                );

                                final index = events.indexOf(event);
                                if (index != -1) events[index] = updated;
                              });

                            },
                            child: const Text("참석"),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                final updated = AnnounceVo(
                                  title: event.title,
                                  date: event.date,
                                  time: event.time,
                                  location: event.location,
                                  description: event.description,
                                  meetingPrice: event.meetingPrice,
                                  memberList: event.memberList,
                                  attendingCount: event.attendingCount - 1,
                                  type: event.type,
                                  updDate: event.updDate,
                                );

                                final index = events.indexOf(event);
                                if (index != -1) events[index] = updated;
                              });
                            },
                            child: const Text("불참"),
                          ),
                        ],
                      ),

                      if (widget.clubLeaderId == widget.currentUserId)
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddMeetingPage(
                                  selectedDate: selectedDay,
                                  existingSchedule: event,
                                ),
                              ),
                            );
                          },
                          child: const Text("일정 수정하기"),
                        ),
                      const Divider(),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final List<AnnounceVo> announcements =
    clubSchedules.where((s) => s.isAnnounce).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final latestNotice = announcements.isNotEmpty ? announcements.first : null;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          if (latestNotice != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AnnouncementListPage(announcements: announcements),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "📢 ${latestNotice.title}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          const SizedBox(height: 12),
          ScheduleCalendar(
            scheduleMap: scheduleMap,
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
                _showSchedule = false;
              });
            },
            onDayLongPressed: (selected, focused) {
              final dateKey = DateTime.utc(selected.year, selected.month, selected.day);
              final events = scheduleMap[dateKey] ?? [];
              if (events.isNotEmpty) {
                _showScheduleDialog(selectedDay: selected, events: events);
              }
            },
          ),
          const SizedBox(height: 12),
          if (_selectedDay != null && scheduleMap[_selectedDay] != null)
            Column(
              children: [
                if (!_showSchedule)
                  ElevatedButton(
                    onPressed: () => setState(() => _showSchedule = true),
                    child: const Text("일정보기"),
                  )
                else
                  ...scheduleMap[_selectedDay]!.map((schedule) {
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        title: Text(schedule.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${schedule.date} / ${schedule.time}"),
                            Text("장소: ${schedule.location}"),
                            Text("회비: ${schedule.meetingPrice}"),
                          ],
                        ),
                        onTap: () {
                          final dateKey = DateTime.utc(
                            _selectedDay!.year,
                            _selectedDay!.month,
                            _selectedDay!.day,
                          );
                          final events = scheduleMap[dateKey] ?? [];
                          _showScheduleDialog(selectedDay: _selectedDay!, events: events);
                        },
                      ),
                    );
                  }),
              ],
            )
          else if (_selectedDay == null)
            const Text("날짜를 선택해 주세요")
          else
            Column(
              children: [
                const Text("해당 날짜에 일정이 없습니다."),
                if (widget.clubLeaderId == widget.currentUserId)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddMeetingPage(selectedDate: _selectedDay!),
                        ),
                      );
                    },
                    child: const Text('일정 추가하기'),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
