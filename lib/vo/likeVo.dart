import 'package:dio/dio.dart';

class LikeVo {
  final int likeId;
  final int postId;
  final int userId;
  final DateTime? updDate;

  LikeVo({
    required this.likeId,
    required this.postId,
    required this.userId,
    this.updDate,
  });

  factory LikeVo.fromJson(Map<String, dynamic> json) {
    return LikeVo(
      likeId: json['like_id'],
      postId: json['post_id'],
      userId: json['user_id'],
      updDate: json['upd_date'] != null ? DateTime.parse(json['upd_date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'like_id': likeId,
      'post_id': postId,
      'user_id': userId,
      'upd_date': updDate?.toIso8601String(),
    };
  }
}

class LikeService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://43.201.50.194:18090/api/like',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    sendTimeout: const Duration(seconds: 5),
    contentType: 'application/json',
  ));

  /// ✅ 좋아요 토글 및 좋아요 수 반환
  static Future<Map<String, dynamic>> toggleLike({required int postId, required int userId}) async {
    try {
      final response = await _dio.post(
        '/toggle',
        queryParameters: {
          'post_id': postId,
          'user_id': userId,
        },
      );

      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      print('❌ toggleLike 에러: $e');
      rethrow;
    }
  }

  /// ✅ 해당 유저가 좋아요 누른 게시물 ID 리스트 조회
  static Future<List<int>> getLikedPostIds(int userId) async {
    try {
      final response = await _dio.get(
        '/checkAll',
        queryParameters: {
          'user_id': userId,
        },
      );
      final data = response.data;
      if (data is Map && data.containsKey('likedPostIds')) {
        return List<int>.from(data['likedPostIds']);
      }
      return [];
    } catch (e) {
      print('❌ getLikedPostIds 에러: $e');
      rethrow;
    }
  }
}
