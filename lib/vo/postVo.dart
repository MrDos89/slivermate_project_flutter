import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:slivermate_project_flutter/vo/commentVo.dart';
import 'package:dio/dio.dart';
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
  });

  //  JSON → LessonVO 변환
  factory PostVo.fromJson(Map<String, dynamic> json) {
    return PostVo(
      postId: json['post_id'] ?? 0,
      regionId: json['region_id'] ?? 0,
      postUserId: json['post_user_id'] ?? 0,
      clubId: json['club_id'] ?? 0,
      postCategoryId: json['post_category_id'] ?? 0,
      postSubCategoryId: json['post_sub_category_id'] ?? 0,
      postNote: json['post_note'] ?? "",
      postImages: (json['post_images'] != null)
        ? List<String>.from(json['post_images'])
        : [],
      postLikeCount: json['post_like_count'] ?? 0,
      postCommentCount: json['post_comment_count'] ?? 0,
      registerDate: DateTime.parse(json['register_date']),
      comments: json['comments'] ?? [],
      isHidden: json['is_hidden'] ?? false,
      postReportCount: json['post_report_count'] ?? 0,
      updDate: DateTime.parse(json['upd_date']),

      userNickname: json['nickname'] ?? "",
      userThumbnail: json['user_thumbnail'] ?? "",
    );
  }

  //  postVo → JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
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
      'upd_date': updDate.toIso8601String(),
    };
  }
}

//  API 요청을 처리하는 함수
class PostService {
  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");
  static final String apiEndpoint = "http://$ec2IpAddress:$ec2Port/api/post";
  static final Dio dio = Dio();

  static Future<List<PostVo>> fetchPostData() async {
    try {
      final response = await dio.get(apiEndpoint);

      debugPrint(' [API 응답 성공] 상태 코드: ${response.statusCode}');
      debugPrint(' [API 응답 데이터]: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List && response.data.isNotEmpty) {
          if (response.data is List) {
            final List<dynamic> rawList = response.data;

            final List<PostVo> postList =
                rawList
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
          return Future.value([]);
        }
      } else {
        debugPrint('⚠ [서버 응답 이상] 코드: ${response.statusCode}');
        return Future.value([]);
      }
    } catch (e) {
      debugPrint(' [API 요청 실패] 오류 발생: $e');
      return Future.value([]);
    }
  }
}
