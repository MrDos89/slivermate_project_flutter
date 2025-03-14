import 'dart:convert';

class LessonVO {
  final int lessonId;
  final int userId;
  final String lessonName;
  final String lessonDesc;
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

  LessonVO({
    required this.lessonId,
    required this.userId,
    required this.lessonName,
    required this.lessonDesc,
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
  });

  // 🔥 JSON → LessonVO 변환
  factory LessonVO.fromJson(Map<String, dynamic> json) {
    return LessonVO(
      lessonId: json['lesson_id'] as int,
      userId: json['user_id'] as int,
      lessonName: json['lesson_name'] as String,
      lessonDesc: json['lesson_desc'] as String,
      lessonCategory: json['lesson_category'] as int,
      lessonSubCategory: json['lesson_sub_category'] as int,
      lessonFreeLecture: json['lesson_free_lecture'] as String,
      lessonCostLecture: json['lesson_cost_lecture'] as String,
      lessonThumbnail: json['lesson_thumbnail'] as String,
      lessonPrice: json['lesson_price'] as int,
      registerDate: json['register_date'] as String,
      isHidden: json['is_hidden'] as bool,
      updDate: json['upd_date'] as String,
      userName: json['user_name'] as String,
      userThumbnail: json['user_thumbnail'] as String,
    );
  }

  // 🔥 LessonVO → JSON 변환 (결제 서버로 보낼 때 사용)
  Map<String, dynamic> toJson() {
    return {
      'lesson_id': lessonId,
      'user_id': userId,
      'lesson_name': lessonName,
      'lesson_desc': lessonDesc,
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
    };
  }
}
