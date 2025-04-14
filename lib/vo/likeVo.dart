import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

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
  ));

  /// 1. 좋아요 토글
  static Future<bool> toggleLike(int postId, int userId) async {
    try {
      final response = await _dio.post('/toggle', data: {
        'post_id': postId,
        'user_id': userId,
      });
      return response.statusCode == 200;
    } catch (e) {
      print('❌ toggleLike error: $e');
      return false;
    }
  }

  /// 2. 해당 게시글을 좋아요 눌렀는지
  static Future<bool> isLiked(int postId, int userId) async {
    try {
      final response = await _dio.get('/is-liked', queryParameters: {
        'post_id': postId,
        'user_id': userId,
      });
      return response.data == true;
    } catch (e) {
      print('❌ isLiked error: $e');
      return false;
    }
  }

  /// 3. 유저가 좋아요 누른 게시글 ID 리스트
  static Future<List<int>> getLikedPostIds(int userId) async {
    try {
      final response = await _dio.get('/checkAll', queryParameters: {
        'user_id': userId,
      });
      final List<dynamic> data = response.data["likedPostIds"];
      return data.cast<int>();
    } catch (e) {
      print('❌ getLikedPostIds error: $e');
      return [];
    }
  }

  /// 4. 특정 게시글의 좋아요 수
  static Future<int> getLikeCount(int postId) async {
    try {
      final response = await _dio.get('/count', queryParameters: {
        'post_id': postId,
      });
      return response.data;
    } catch (e) {
      print('❌ getLikeCount error: $e');
      return 0;
    }
  }
}


