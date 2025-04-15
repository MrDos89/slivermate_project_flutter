import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../vo/announceVo.dart';

class AnnouncementService {
  static final Dio dio = Dio(
    BaseOptions(baseUrl: 'http://43.201.50.194:18090/api'),
  );

  // 일정 리스트 가져오기
  static Future<List<AnnounceVo>> fetchSchedules(int clubId) async {
    try {
      final response = await dio.get('/announcement/club/$clubId');
      final data = response.data as List;
      return data.map((json) => AnnounceVo.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ 일정 불러오기 실패: $e');
      return [];
    }
  }

  // 참석 요청
  static Future<bool> attend(int announcementId, int userId) async {
    try {
      final response = await dio.post(
        '/announcement/$announcementId/attend',
        data: {'user_id': userId},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ 참석 실패: $e');
      return false;
    }
  }

  // 불참 요청
  static Future<bool> unAttend(int announcementId, int userId) async {
    try {
      final response = await dio.post(
        '/announcement/$announcementId/unattend',
        data: {'user_id': userId},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ 불참 실패: $e');
      return false;
    }
  }
}
