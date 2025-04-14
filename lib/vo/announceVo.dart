class AnnounceVo {
  final String title;
  final String date;
  final String time;
  final String location;
  final String description;
  final List<String> memberList; //  추가
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
    required this.memberList,
    required this.meetingPrice,
    required this.attendingCount,
    required this.type,
    required this.updDate,
  });

  /// 공지인지 확인
  bool get isAnnounce => type == 1;

  /// 모임인지 확인
  bool get isMeeting => type == 2;

  /// JSON → AnnounceVo
  factory AnnounceVo.fromJson(Map<String, dynamic> json) {
    return AnnounceVo(
      title: json['announce_title'] ?? '',
      date: json['announce_date'] ?? '',
      time: json['announce_time'] ?? '',
      location: json['announce_location'] ?? '',
      description: json['announce_desc'] ?? '',
      memberList: List<String>.from(json['member_list'] ?? []), //  추가
      meetingPrice: json['meeting_price'].toString(),
      attendingCount: json['attend_count'] ?? 0,
      type: json['announce_type'] ?? 1,
      updDate: DateTime.parse(json['upd_date']),
    );
  }

  /// AnnounceVo → JSON
  Map<String, dynamic> toJson() {
    return {
      'announce_title': title,
      'announce_date': date,
      'announce_time': time,
      'announce_location': location,
      'announce_desc': description,
      'member_list': memberList, //  추가
      'meeting_price': meetingPrice,
      'attend_count': attendingCount,
      'announce_type': type,
      'upd_date': updDate.toIso8601String(),
    };
  }
}
