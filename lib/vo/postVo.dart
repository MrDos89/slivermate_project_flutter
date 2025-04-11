import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:slivermate_project_flutter/vo/commentVo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PostVo {
  final int postId;
  final int regionId;
  final int postUserId;
  final int clubId;
  final int postCategoryId;
  final int postSubCategoryId;
  final String postNote;
  final List<String>? postImages;
  int postLikeCount;
  int postCommentCount;
  final bool isHidden;
  final int postReportCount;
  final DateTime registerDate;
  final List<CommentVo> comments;

  final String userNickname;
  final String userThumbnail;
  final DateTime updDate;
  final bool likedByMe;

  PostVo({
    required this.postId,
    required this.regionId,
    required this.postUserId,
    required this.clubId,
    required this.postCategoryId,
    required this.postSubCategoryId,
    required this.postNote,
    required this.postImages,
    required this.postLikeCount,
    required this.postCommentCount,
    required this.isHidden,
    required this.postReportCount,
    required this.registerDate,
    required this.comments,
    required this.userNickname,
    required this.userThumbnail,
    required this.updDate,
    required this.likedByMe,
  });

  //  JSON → LessonVO 변환
  factory PostVo.fromJson(Map<String, dynamic> json) {
    debugPrint('📦 서버에서 받은 register_date: ${json['register_date']}');
    final parsedRegisterDate = DateTime.parse(json['register_date']).toUtc();  // UTC 기준으로 파싱
    debugPrint('🕓 최종 파싱된 registerDate (UTC): $parsedRegisterDate');  // UTC로 확인

    return PostVo(
      postId: json['post_id'] ?? 0,
      regionId: json['region_id'] ?? 0,
      postUserId: json['post_user_id'] ?? 0,
      clubId: json['club_id'] ?? 0,
      postCategoryId: json['post_category_id'] ?? 0,
      postSubCategoryId: json['post_sub_category_id'] ?? 0,
      postNote: json['post_note'] ?? "",
      postImages: (json['post_images'] != null) ? List<String>.from(json['post_images']) : [],
      postLikeCount: json['post_like_count'] ?? 0,
      postCommentCount: json['post_comment_count'] ?? 0,
      registerDate: parsedRegisterDate.toLocal(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentVo.fromJson(e))
          .toList() ?? [],
      isHidden: json['is_hidden'] ?? false,
      postReportCount: json['post_report_count'] ?? 0,
      updDate: DateTime.parse(json['upd_date']).toLocal(),

      userNickname: json['nickname'] ?? "",
      userThumbnail: json['user_thumbnail'] ?? "",
      likedByMe: json['liked_by_me'] == true,
    );
  }


  //  postVo → JSON 변환
  Map<String, dynamic> toJson() {
    return {
      // 'post_id': postId,
      'region_id': regionId,
      'post_user_id': postUserId,
      'club_id': clubId,
      'post_category_id': postCategoryId,
      'post_sub_category_id': postSubCategoryId,
      'post_note': postNote,
      'post_images': postImages,
      'post_like_count': postLikeCount,
      'post_comment_count': postCommentCount,
      'is_hidden': isHidden,
      'post_report_count': postReportCount,
      'register_date': registerDate.toIso8601String(),
      'comments': comments,
      'nickname': userNickname,
      'user_thumbnail': userThumbnail,
      'liked_by_me': likedByMe,
      // 'upd_date': updDate.toIso8601String(),
    };
  }
}

//  API 요청을 처리하는 함수
class PostService {
  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");
  static final String apiEndpoint = "http://$ec2IpAddress:$ec2Port/api/post";
  static final Dio dio = Dio();

  static Future<List<PostVo>> fetchPostData(int userId) async {
    try {
      final response = await dio.get(apiEndpoint, queryParameters: {'user_id': userId});  // userId를 쿼리 파라미터로 전달

      debugPrint(' [API 응답 성공] 상태 코드: ${response.statusCode}');
      debugPrint(' [API 응답 데이터]: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List && response.data.isNotEmpty) {
          final List<dynamic> rawList = response.data;

          final List<PostVo> postList = rawList
              .map(
                (item) => PostVo.fromJson(item as Map<String, dynamic>),
          )
              .toList();

          return postList;
        } else {
          debugPrint('⚠ [응답이 List가 아님]');
          return [];
        }
      } else {
        debugPrint('⚠ [서버 응답 이상] 코드: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint(' [API 요청 실패] 오류 발생: $e');
      return [];
    }
  }
  static Future<List<PostVo>> fetchPostsWithLikes(int userId) async {
    try {
      final response = await dio.get('$apiEndpoint/with-like', queryParameters: {'user_id': userId});
      if (response.statusCode == 200) {
        final List<PostVo> posts = (response.data as List)
            .map((e) => PostVo.fromJson(e as Map<String, dynamic>))
            .toList();
        return posts;
      } else {
        throw Exception('Failed to load posts with likes');
      }
    } catch (e) {
      print('Error fetching posts with likes: $e');
      rethrow;
    }
  }

  // 좋아요 토글하기
  static Future<bool> toggleLike({required int postId, required int userId}) async {
    try {
      final response = await dio.patch(
        '/updateCount',
        data: {'post_id': postId, 'user_id': userId},
      );
      if (response.statusCode == 200) {
        return response.data['liked'] == true;
      } else {
        throw Exception('Failed to toggle like');
      }
    } catch (e) {
      print('Error toggling like: $e');
      rethrow;
    }
  }
}
