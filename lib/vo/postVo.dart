import 'package:dio/dio.dart';

class PostVo {
  final String userThumbnail;
  final String userNickname;
  final int regionId;
  final int categoryNames;
  final int subCategory;
  final String postNote;

  PostVo({
    required this.userThumbnail,
    required this.userNickname,
    required this.regionId,
    required this.categoryNames,
    required this.subCategory,
    required this.postNote,
  });
}