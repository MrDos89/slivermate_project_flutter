import 'dart:convert';

class UserVo {
  final int uid; // 유저 회원번호
  final String userName; // 이름
  final String nickname; // 닉네임
  final String userId; // 유저 아이디
  final String userPassword; // 비밀번호
  final String telNumber; // 전화번호
  final String email; // 이메일
  final String thumbnail; // 썸네일 주소 (프로필 이미지)
  final int guId; // 구 정보
  final int? recommendUid; // 추천인 회원번호 (nullable)
  final String registerDate; // 가입일자
  final bool isDeleted; // 탈퇴 여부
  final bool isAdmin; // 관리자 계정 여부
  final String updDate; // 갱신 시간

  UserVo({
    required this.uid,
    required this.userName,
    required this.nickname,
    required this.userId,
    required this.userPassword,
    required this.telNumber,
    required this.email,
    required this.thumbnail,
    required this.guId,
    this.recommendUid, // nullable
    required this.registerDate,
    required this.isDeleted,
    required this.isAdmin,
    required this.updDate,
  });

  //  JSON → UserVo 변환
  factory UserVo.fromJson(Map<String, dynamic> json) {
    return UserVo(
      uid: json['uid'] ?? 0,
      userName: json['user_name'] ?? "이름 없음",
      nickname: json['nickname'] ?? "닉네임 없음",
      userId: json['user_id'] ?? "아이디 없음",
      userPassword: json['user_password'] ?? "비밀번호 없음",
      telNumber: json['tel_number'] ?? "전화번호 없음",
      email: json['email'] ?? "이메일 없음",
      thumbnail: json['thumbnail'] ?? "", // 빈 문자열로 기본값 설정
      guId: json['gu_id'] ?? 0,
      recommendUid: json['recommend_uid'], // nullable
      registerDate: json['register_date'] ?? "날짜 없음",
      isDeleted: json['is_deleted'] ?? false,
      isAdmin: json['is_admin'] ?? false,
      updDate: json['upd_date'] ?? "날짜 없음",
    );
  }

  //  UserVo → JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'user_name': userName,
      'nickname': nickname,
      'user_id': userId,
      'user_password': userPassword,
      'tel_number': telNumber,
      'email': email,
      'thumbnail': thumbnail,
      'gu_id': guId,
      'recommend_uid': recommendUid,
      'register_date': registerDate,
      'is_deleted': isDeleted,
      'is_admin': isAdmin,
      'upd_date': updDate,
    };
  }
}
