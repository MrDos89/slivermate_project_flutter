class ClubVo {
  final int clubId;
  final String clubName;
  final int clubUserId;
  final int clubCategoryId;
  final int clubSubCategoryId;
  final String clubThumbnail;
  final String clubMovie;
  final String clubDesc;
  final int clubMemberNumber;
  final int clubMemberMax;
  final int clubReportCnt;
  final DateTime clubRegisterDate;
  final bool isDeleted;
  final DateTime updDate;

  ClubVo({
    required this.clubId,
    required this.clubName,
    required this.clubUserId,
    required this.clubCategoryId,
    required this.clubSubCategoryId,
    required this.clubThumbnail,
    required this.clubMovie,
    required this.clubDesc,
    required this.clubMemberNumber,
    required this.clubMemberMax,
    required this.clubReportCnt,
    required this.clubRegisterDate,
    required this.isDeleted,
    required this.updDate,
  });

  factory ClubVo.fromJson(Map<String, dynamic> json) {
    return ClubVo(
      clubId: json['club_id'],
      clubName: json['club_name'],
      clubUserId: json['club_user_id'],
      clubCategoryId: json['club_category_id'],
      clubSubCategoryId: json['club_sub_category_id'],
      clubThumbnail: json['club_thumbnail'] ?? '',
      clubMovie: json['club_movie'] ?? '',
      clubDesc: json['club_desc'] ?? '',
      clubMemberNumber: json['club_member_number'] ?? 0,
      clubMemberMax: json['club_member_max'] ?? 0,
      clubReportCnt: json['club_report_cnt'] ?? 0,
      clubRegisterDate: DateTime.parse(json['club_register_date']),
      isDeleted: json['is_deleted'] ?? false,
      updDate: DateTime.parse(json['upd_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'club_id': clubId,
      'club_name': clubName,
      'club_user_id': clubUserId,
      'club_category_id': clubCategoryId,
      'club_sub_category_id': clubSubCategoryId,
      'club_thumbnail': clubThumbnail,
      'club_movie': clubMovie,
      'club_desc': clubDesc,
      'club_member_number': clubMemberNumber,
      'club_member_max': clubMemberMax,
      'club_report_cnt': clubReportCnt,
      'club_register_date': clubRegisterDate.toIso8601String(),
      'is_deleted': isDeleted,
      'upd_date': updDate.toIso8601String(),
    };
  }
}
