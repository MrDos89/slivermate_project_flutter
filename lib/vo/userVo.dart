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
  final int regionId; // 구 정보
  final int? recommendUid; // 추천인 회원번호 (nullable)
  final String registerDate; // 가입일자
  final bool isDeleted; // 탈퇴 여부
  final bool isAdmin; // 관리자 계정 여부
  final String updDate; // 갱신 시간
  final int groupId; // 유저 그룹 아이디
  final int userType; // 유저 타입(11: 부모1, 2: 부모2, 3: 자식1, 4: 자식2)
  final String pinPassword; // PIN 비밀번호

  UserVo({
    required this.uid,
    required this.userName,
    required this.nickname,
    required this.userId,
    required this.userPassword,
    required this.telNumber,
    required this.email,
    required this.thumbnail,
    required this.regionId,
    this.recommendUid, // nullable
    required this.registerDate,
    required this.isDeleted,
    required this.isAdmin,
    required this.updDate,
    required this.groupId,
    required this.pinPassword,
    required this.userType,
  });

  //  JSON → UserVo 변환
  factory UserVo.fromJson(Map<String, dynamic> json) {
    return UserVo(
      uid: json['uid'] ?? 0,
      userName: json['user_name'] ?? "이름 없음",
      nickname: json['nickname'] ?? "닉네임 없음",
      userId: json['user_id'] ?? "아이디 없음",
      userPassword: json['user_password'] ?? "비밀번호 없음",
      pinPassword: json['pin_password'] ?? "0000",
      telNumber: json['tel_number'] ?? "전화번호 없음",
      email: json['email'] ?? "이메일 없음",
      thumbnail: json['thumbnail'] ?? "",
      regionId: json['region_id'] ?? 0,
      recommendUid: json['recommend_uid'],
      registerDate: json['register_date'] ?? "날짜 없음",
      isDeleted: json['is_deleted'] ?? false,
      isAdmin: json['is_admin'] ?? false,
      updDate: json['upd_date'] ?? "날짜 없음",
      groupId: json['group_id'] ?? 0,
      userType: json['user_type'] ?? 1,
    );
  }

// UserVo → JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'user_name': userName,
      'nickname': nickname,
      'user_id': userId,
      'user_password': userPassword,
      'pin_password': pinPassword,
      'tel_number': telNumber,
      'email': email,
      'thumbnail': thumbnail,
      'region_id': regionId,
      'recommend_uid': recommendUid,
      'register_date': registerDate,
      'is_deleted': isDeleted,
      'is_admin': isAdmin,
      'upd_date': updDate,
      'group_id': groupId,
      'user_type': userType,
    };
  }
}