import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ClubVo {
  final int clubId;
  final String clubName;
  final int clubUserId;
  final String clubUserNickname;
  final int clubCategoryId;
  final int clubSubCategoryId;
  final String clubThumbnail;
  final String clubMovie;
  final String clubDesc;
  final int clubMemberNumber;
  final int clubMemberMax;
  final int clubReportCnt;
  final DateTime clubRegisterDate;
  final bool isDeleted;
  final DateTime updDate;

  ClubVo({
    required this.clubId,
    required this.clubName,
    required this.clubUserId,
    required this.clubUserNickname,
    required this.clubCategoryId,
    required this.clubSubCategoryId,
    required this.clubThumbnail,
    required this.clubMovie,
    required this.clubDesc,
    required this.clubMemberNumber,
    required this.clubMemberMax,
    required this.clubReportCnt,
    required this.clubRegisterDate,
    required this.isDeleted,
    required this.updDate,
  });

  factory ClubVo.fromJson(Map<String, dynamic> json) {
    return ClubVo(
      clubId: json['club_id'],
      clubName: json['club_name'],
      clubUserId: json['club_user_id'],
      clubUserNickname: json['user_name'],
      clubCategoryId: json['club_category_id'],
      clubSubCategoryId: json['club_sub_category_id'],
      clubThumbnail: json['club_thumbnail'] ?? '',
      clubMovie: json['club_movie'] ?? '',
      clubDesc: json['club_desc'] ?? '',
      clubMemberNumber: json['club_member_number'] ?? 0,
      clubMemberMax: json['club_member_max'] ?? 0,
      clubReportCnt: json['club_report_cnt'] ?? 0,
      clubRegisterDate: DateTime.parse(json['club_register_date']),
      isDeleted: json['is_deleted'] ?? false,
      updDate: DateTime.parse(json['upd_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'club_id': clubId,
      'club_name': clubName,
      'club_user_id': clubUserId,
      'club_user_nickname': clubUserNickname,
      'club_category_id': clubCategoryId,
      'club_sub_category_id': clubSubCategoryId,
      'club_thumbnail': clubThumbnail,
      'club_movie': clubMovie,
      'club_desc': clubDesc,
      'club_member_number': clubMemberNumber,
      'club_member_max': clubMemberMax,
      'club_report_cnt': clubReportCnt,
      'club_register_date': clubRegisterDate.toIso8601String(),
      'is_deleted': isDeleted,
      'upd_date': updDate.toIso8601String(),
    };
  }
}

final Dio dio = Dio(
  BaseOptions(
    baseUrl: 'http://43.201.50.194:18090/api',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    contentType: 'application/json',
  ),
);

Future<List<ClubVo>> fetchClubsFromServer() async {
  debugPrint("🚀 클럽 데이터 요청 중...");

  try {
    final response = await dio.get('/club');
    debugPrint("🎯 응답 상태: ${response.statusCode}");

    final raw = response.data;
    debugPrint("📦 응답 원본: $raw");

    final List<ClubVo> clubs = (raw as List)
        .map((json) => ClubVo.fromJson(json))
        .toList();

    return clubs;
  } catch (e, st) {
    debugPrint("❌ 오류 발생: $e");
    debugPrint("🧱 스택: $st");
    return [];
  }
}
