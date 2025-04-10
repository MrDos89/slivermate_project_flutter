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


// Api연결
class LikeService {
  static final Dio _dio = Dio();

  /// 좋아요 추가/삭제 (toggle)
  static Future<bool> toggleLike({required int postId, required int userId}) async {
    try {
      final response = await _dio.post(
        'http://3.39.240.55:18090/api/like',
        queryParameters: {
          'postId': postId,
          'userId': userId,
        },
      );
      return response.data == 'liked';
    } catch (e) {
      print('❌ toggleLike 에러: $e');
      rethrow;
    }
  }

  /// 좋아요 상태 조회
  static Future<Map<String, dynamic>> getLikeStatus({required int postId, required int userId}) async {
    try {
      final response = await _dio.get(
        'http://3.39.240.55:18090/api/like/status',
        queryParameters: {
          'postId': postId,
          'userId': userId,
        },
      );
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      print('❌ getLikeStatus 에러: $e');
      rethrow;
    }
  }

  /// 좋아요 여부 확인 (단건)
  static Future<bool> isLiked({required int postId, required int userId}) async {
    try {
      final response = await _dio.get(
        'http://3.39.240.55:18090/api/like/check',
        queryParameters: {
          'postId': postId,
          'userId': userId,
        },
      );
      return response.data == true;
    } catch (e) {
      print('❌ isLiked 에러: $e');
      rethrow;
    }
  }

  /// 해당 유저가 좋아요 누른 게시물 ID 리스트 조회
  static Future<List<int>> getLikedPostIds(int userId) async {
    try {
      final response = await _dio.get(
        'http://3.39.240.55:18090/api/like/checkAll',
        queryParameters: {
          'userId': userId,
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