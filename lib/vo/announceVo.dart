class AnnounceVo {
  final String title;
  final String date;
  final String time;
  final String location;
  final String description;
  final String meetingPrice;
  final int attendingCount;
  final int type; // 1: 공지 / 2: 모임

  const AnnounceVo({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.meetingPrice,
    required this.attendingCount,
    required this.type,
  });

  bool get isAnnounce => type == 1;
  bool get isMeeting => type == 2;
}
