import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/cupertino.dart';

class UserVo {
  final int uid; // 유저 회원번호
  final int groupId; // 유저 그룹 아이디
  final int userType; // 유저 타입(11: 부모1, 2: 부모2, 3: 자식1, 4: 자식2)
  final String userName; // 이름
  final String nickname; // 닉네임
  final String userId; // 유저 아이디
  final String userPassword; // 비밀번호
  final String pinPassword; // PIN 비밀번호
  final String telNumber; // 전화번호
  final String email; // 이메일
  final String thumbnail; // 썸네일 주소 (프로필 이미지)
  final int regionId; // 지역번호
  final DateTime registerDate; // 가입일자
  final bool isDeleted; // 유저정보(탈퇴) 삭제 여부
  final bool isAdmin; // 관리자 계정 여부
  final DateTime updDate; // 갱신 시간
  // final int? recommendUid; // 추천인 회원번호 (nullable)

  UserVo({
    required this.uid,
    required this.groupId,
    required this.userType,
    required this.userName,
    required this.nickname,
    required this.userId,
    required this.userPassword,
    required this.pinPassword,
    required this.telNumber,
    required this.email,
    required this.thumbnail,
    required this.regionId,
    required this.registerDate,
    required this.isDeleted,
    required this.isAdmin,
    required this.updDate,
    // this.recommendUid, // nullable
  });

  //  JSON → UserVo 변환
  factory UserVo.fromJson(Map<String, dynamic> json) {
    return UserVo(
      uid: json['uid'] ?? 0,
      groupId: json['group_id'] ?? 0,
      userType: json['user_type'] ?? 1,
      userName: json['user_name'] ?? "이름 없음",
      nickname: json['nickname'] ?? "닉네임 없음",
      userId: json['user_id'] ?? "아이디 없음",
      userPassword: json['user_password'] ?? "비밀번호 없음",
      pinPassword: json['pin_password'] ?? "0000",
      telNumber: json['tel_number'] ?? "전화번호 없음",
      email: json['email'] ?? "이메일 없음",
      thumbnail: json['thumbnail'] ?? "",
      regionId: json['region_id'] ?? 0,
      // registerDate: DateTime.parse(json['register_date']),
      registerDate:
          json['register_date'] != null
              ? DateTime.parse(json['register_date'])
              : DateTime.now(),
      isDeleted: json['is_deleted'] ?? false,
      isAdmin: json['is_admin'] ?? false,
      // updDate: DateTime.parse(json['upd_date']),
      updDate:
          json['upd_date'] != null
              ? DateTime.parse(json['upd_date'])
              : DateTime.now(),
      // recommendUid: json['recommend_uid'],
    );
  }

  // UserVo → JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'group_id': groupId,
      'user_type': userType,
      'user_name': userName,
      'nickname': nickname,
      'user_id': userId,
      'user_password': userPassword,
      'pin_password': pinPassword,
      'tel_number': telNumber,
      'email': email,
      'thumbnail': thumbnail,
      'region_id': regionId,
      'register_date': registerDate,
      'is_deleted': isDeleted,
      'is_admin': isAdmin,
      'upd_date': updDate,
      // 'recommend_uid': recommendUid,
    };
  }
}

//  API 요청을 처리하는 함수
class UserService {
  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");
  static final String apiEndpoint = "http://$ec2IpAddress:$ec2Port/api/user";
  static final Dio dio = Dio();

  static Future<List<UserVo>> fetchUserData() async {
    try {
      final response = await dio.get(apiEndpoint);

      debugPrint(' [API 응답 성공] 상태 코드: ${response.statusCode}');
      debugPrint(' [API 응답 데이터]: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List && response.data.isNotEmpty) {
          if (response.data is List) {
            final List<dynamic> rawList = response.data;

            final List<UserVo> userList =
                rawList
                    .map(
                      (item) => UserVo.fromJson(item as Map<String, dynamic>),
                    )
                    .toList();

            return userList;
          } else {
            debugPrint(' [응답이 List가 아님]');
            return [];
          }
        } else {
          return Future.value([]);
        }
      } else {
        debugPrint('[서버 응답 이상] 코드: ${response.statusCode}');
        return Future.value([]);
      }
    } catch (e) {
      debugPrint(' [API 요청 실패] 오류 발생: $e');
      return Future.value([]);
    }
  }
}
