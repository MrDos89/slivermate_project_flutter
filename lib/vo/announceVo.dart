class AnnounceVo {
  final String title;
  final String date;
  final String time;
  final String location;
  final String description;
  final String meetingPrice;
  final int attendingCount;
  final int type; // 1: 공지 / 2: 모임
  final DateTime updDate;

  const AnnounceVo({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.meetingPrice,
    required this.attendingCount,
    required this.type,
    required this.updDate,
  });

  //  공지인지 확인
  bool get isAnnounce => type == 1;

  //  모임인지 확인
  bool get isMeeting => type == 2;

  //  JSON → AnnounceVo 변환
  factory AnnounceVo.fromJson(Map<String, dynamic> json) {
    return AnnounceVo(
      title: json['announce_title'] ?? '',
      date: json['announce_date'] ?? '',
      time: json['announce_time'] ?? '',
      location: json['announce_location'] ?? '',
      description: json['announce_desc'] ?? '',
      meetingPrice: json['meeting_price'].toString(), // int → String
      attendingCount: json['attend_count'] ?? 0,
      type: json['announce_type'] ?? 1,
      updDate: DateTime.parse(json['upd_date']),
    );
  }

  //  AnnounceVo → JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'announce_title': title,
      'announce_date': date,
      'announce_time': time,
      'announce_location': location,
      'announce_desc': description,
      'meeting_price': meetingPrice,
      'attend_count': attendingCount,
      'announce_type': type,
      'upd_date': updDate.toIso8601String(),
    };
  }
}
