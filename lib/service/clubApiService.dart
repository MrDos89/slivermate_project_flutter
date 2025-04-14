import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../vo/clubVo.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: 'http://43.201.50.194:18090/api',
    contentType: 'application/json',
  ),
);

Future<void> createClub(ClubVo club) async {
  try {
    final response = await dio.post(
      '/club',
      data: club.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('✅ 클럽 생성 성공');
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('❌ 클럽 생성 실패: $e');
    rethrow;
  }
}

