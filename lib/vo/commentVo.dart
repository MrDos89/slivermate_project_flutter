import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class CommentVo {
  final String userThumbnail;
  final String userNickname;
  final String commentText;
  final DateTime commentDate;

  CommentVo({
    required this.userThumbnail,
    required this.userNickname,
    required this.commentText,
    required this.commentDate,
  });

  /// JSON → CommentVo
  factory CommentVo.fromJson(Map<String, dynamic> json) {
    return CommentVo(
      userThumbnail: json['user_thumbnail'] ?? '',
      userNickname: json['user_nickname'] ?? '',
      commentText: json['comment_text'] ?? '',
      commentDate: DateTime.parse(json['upd_date']).toLocal(),
    );
  }

  /// CommentVo → JSON
  Map<String, dynamic> toJson() {
    return {
      'user_thumbnail': userThumbnail,
      'nickname': userNickname,
      'content': commentText,
      'register_date': commentDate.toIso8601String(),
    };
  }
}


class CommentService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://43.201.50.194:18090/api/comment',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  /// ✅ 댓글 등록 (최신 버전)
  static Future<bool> addComment({
    required int postId,
    required int userId,
    required int clubId,
    required String commentText,
  }) async {
    try {
      final response = await _dio.post(
        '/newcomment',
        data: {
          "post_id": postId,
          "user_id": userId,
          "club_id": clubId,
          "comment_text": commentText,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("❌ 댓글 등록 실패: $e");
      return false;
    }
  }

  /// ✅ 댓글 불러오기
  static Future<List<CommentVo>> fetchComments(int postId) async {
    debugPrint("🟡 fetchComments 호출됨: postId = $postId");

    try {
      final response = await _dio.get(
        '/by-post',
        queryParameters: {'post_id': postId},
      );

      debugPrint("🟢 서버 응답 상태 코드: ${response.statusCode}");
      debugPrint("🟢 응답 바디: ${response.data}");

      if (response.statusCode == 200) {
        final List data = response.data;

        final comments = data.map((e) => CommentVo.fromJson(e)).toList();

        debugPrint("🟢 파싱 완료. 댓글 수: ${comments.length}");

        return comments;
      } else {
        debugPrint("🔴 비정상 응답: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint('❌ fetchComments error: $e');
      return [];
    }
  }
}