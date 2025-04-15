import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:slivermate_project_flutter/vo/announceVo.dart';

class ScheduleCalendar extends StatelessWidget {
  final Map<DateTime, List<AnnounceVo>> scheduleMap;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final void Function(DateTime selected, DateTime focused)? onDaySelected;
  final void Function(DateTime selected, DateTime focused)? onDayLongPressed;

  const ScheduleCalendar({
    super.key,
    required this.scheduleMap,
    required this.focusedDay,
    required this.selectedDay,
    this.onDaySelected,
    this.onDayLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      eventLoader: (day) {
        final dateKey = DateTime.utc(day.year, day.month, day.day);
        return scheduleMap[dateKey]?.where((e) => e.isMeeting).toList() ?? [];
      },
      onDaySelected: onDaySelected,
      onDayLongPressed: onDayLongPressed,
      calendarFormat: CalendarFormat.month,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: const CalendarStyle(
        markersMaxCount: 0,
      ),
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, day, focusedDay) {
          return Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${day.day}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        defaultBuilder: (context, day, focusedDay) {
          final dateKey = DateTime.utc(day.year, day.month, day.day);
          final hasEvents = scheduleMap[dateKey]?.isNotEmpty ?? false;

          if (hasEvents) {
            return Container(
              width: 45,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}