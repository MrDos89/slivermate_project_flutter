import 'package:dio/dio.dart';

/// 🔹 신고 데이터 모델 + API 연동 (Vo + Service 합침)
class SliverVo {
  final int? id; // 신고글 번호
  final int userId; // 신고한 유저 번호
  final int lessonId; // 신고당한 게시글 번호
  final int reportId; // 신고 사유
  final String reportContent; // 🔹 신고 내용
  final bool isConfirmed; // 신고 처리 완료 여부
  final DateTime updDate; // 신고 일시

  SliverVo({
    this.id,
    required this.userId,
    required this.lessonId,
    required this.reportId,
    required this.reportContent,
    required this.isConfirmed,
    required this.updDate,
  });

  /// 🟢 **JSON → 객체 변환 (fromJson)**
  factory SliverVo.fromJson(Map<String, dynamic> json) {
    return SliverVo(
      id: json['id'],
      userId: json['user_id'],
      lessonId: json['lesson_id'],
      reportId: json['report_id'],
      reportContent: json['report_content'] ?? '',
      isConfirmed: json['is_confirmed'],
      updDate: DateTime.parse(json['upd_date']),
    );
  }

  /// 🔵 **객체 → JSON 변환 (toJson)**
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'lesson_id': lessonId,
      'report_id': reportId,
      'report_content': reportContent,
      'is_confirmed': isConfirmed,
      'upd_date': updDate.toIso8601String(),
    };
  }

  /// 🟡 **API 요청 기능 추가 (Dio 사용)**
  static const String apiUrl = "http://13.125.197.66:18090/api/report";
  static final Dio dio = Dio();

  /// 🔹 신고 데이터 전송 (POST)
  static Future<bool> sendReport(SliverVo report) async {
    try {
      Response response = await dio.post(apiUrl, data: report.toJson());

      if (response.statusCode == 200) {
        print("✅ 신고 전송 성공: ${response.data}");
        return true;
      } else {
        print("⚠ 서버 응답 오류: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("🚨 서버 요청 실패: $e");
      return false;
    }
  }

  /// 🔹 신고 내역 조회 (GET)
  static Future<List<SliverVo>> fetchReports() async {
    try {
      Response response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<SliverVo> reports =
            data.map((json) => SliverVo.fromJson(json)).toList();
        print("✅ 신고 내역 가져오기 성공: ${reports.length}개");
        return reports;
      } else {
        print("⚠ 서버 응답 오류: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("🚨 서버 요청 실패: $e");
      return [];
    }
  }
}
