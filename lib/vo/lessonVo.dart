import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LessonVo {
  final int lessonId;
  final int userId;
  final String lessonName;
  final String lessonDesc;
  final String lessonCostDesc;
  final int lessonCategory;
  final int lessonSubCategory;
  final String lessonFreeLecture;
  final String lessonCostLecture;
  final String lessonThumbnail;
  final int lessonPrice;
  final String registerDate;
  final bool isHidden;
  final String updDate;
  final String userName;
  final String userThumbnail;
  final int lessonGroupId;
  final int likeCount;
  final int viewCount;

  LessonVo({
    required this.lessonId,
    required this.userId,
    required this.lessonName,
    required this.lessonDesc,
    required this.lessonCostDesc,
    required this.lessonCategory,
    required this.lessonSubCategory,
    required this.lessonFreeLecture,
    required this.lessonCostLecture,
    required this.lessonThumbnail,
    required this.lessonPrice,
    required this.registerDate,
    required this.isHidden,
    required this.updDate,
    required this.userName,
    required this.userThumbnail,
    required this.lessonGroupId,
    required this.likeCount,
    required this.viewCount,
  });

  //  JSON → LessonVO 변환
  factory LessonVo.fromJson(Map<String, dynamic> json) {
    return LessonVo(
      lessonId: json['lesson_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      lessonName: json['lesson_name'] ?? "없음",
      lessonDesc: json['lesson_desc'] ?? "설명이 없습니다.",
      lessonCostDesc: json['lesson_cost_desc'] ?? "유료 영상 설명이 없습니다.",
      lessonCategory: json['lesson_category'] ?? 0,
      lessonSubCategory: json['lesson_sub_category'] ?? 0,
      lessonFreeLecture: json['lesson_free_lecture'] ?? "",
      lessonCostLecture: json['lesson_cost_lecture'] ?? "",
      lessonThumbnail: json['lesson_thumbnail'] ?? "",
      lessonPrice: json['lesson_price'] ?? 0,
      registerDate: json['register_date'] ?? "없음",
      isHidden: json['is_hidden'] ?? false,
      updDate: json['upd_date'] ?? "없음",
      userName: json['user_name'] ?? "미정",
      userThumbnail: json['user_thumbnail'] ?? "",
      lessonGroupId: json['lesson_group_id'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      viewCount: json['view_count'] ?? 0,
    );
  }

  //  날짜 변환 함수 추가
  String getFormattedDate() {
    if (registerDate.isEmpty || registerDate == "없음") return "날짜 없음"; // 빈 값 처리
    try {
      DateTime dateTime = DateTime.parse(registerDate);
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return "날짜 없음"; // 변환 실패 시 기본값
    }
  }

  //  LessonVO → JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'lesson_id': lessonId,
      'user_id': userId,
      'lesson_name': lessonName,
      'lesson_desc': lessonDesc,
      'lesson_cost_desc': lessonDesc,
      'lesson_category': lessonCategory,
      'lesson_sub_category': lessonSubCategory,
      'lesson_free_lecture': lessonFreeLecture,
      'lesson_cost_lecture': lessonCostLecture,
      'lesson_thumbnail': lessonThumbnail,
      'lesson_price': lessonPrice,
      'register_date': registerDate,
      'is_hidden': isHidden,
      'upd_date': updDate,
      'user_name': userName,
      'user_thumbnail': userThumbnail,
      'lesson_group_id': lessonGroupId,
      'like_count': likeCount,
      'view_count': viewCount,
    };
  }
}

//  API 요청을 처리하는 함수
class LessonService {
  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");
  static final String apiEndpoint = "http://$ec2IpAddress:$ec2Port/api/lesson";
  static final Dio dio = Dio();

  static Future<LessonVo?> fetchLessonData(
    int lessonCategory,
    int lessonSubCategory,
  ) async {
    final String url = "$apiEndpoint/sc/$lessonCategory/$lessonSubCategory";

    print(' [API 요청 시작] 요청 URL: $url');

    try {
      final response = await dio.get(url);

      print(' [API 응답 성공] 상태 코드: ${response.statusCode}');
      print(' [API 응답 데이터]: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List && response.data.isNotEmpty) {
          final parsedLesson = LessonVo.fromJson(response.data[0]);
          print(' [JSON 파싱 성공]');
          return parsedLesson;
        } else {
          print('⚠ [서버 응답 데이터 없음]');
          return null;
        }
      } else {
        print('⚠ [서버 응답 이상] 코드: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(' [API 요청 실패] 오류 발생: $e');
      return null;
    }
  }
}
