import 'package:dio/dio.dart';

class PurchaseVo {
  final int id; //  결제 고유 아이디
  final int sku; //  결제 sku 아이디
  final int uid; //  결제한 유저 아이디
  final int clubId; //  결제한 유저 소속 동아리
  final String receiptId; //  결제 승인증
  final int price; //  결제 가격
  final bool isMonthlyPaid; //  구독 모임인지 여부
  final DateTime? updDate; //  업데이트 날짜 (nullable)

  PurchaseVo({
    required this.id,
    required this.sku,
    required this.uid,
    required this.clubId,
    required this.receiptId,
    required this.price,
    required this.isMonthlyPaid,
    this.updDate,
  });

  //  JSON -> PurchaseVo 변환
  factory PurchaseVo.fromJson(Map<String, dynamic> json) {
    return PurchaseVo(
      id: json['id'] ?? 0,
      sku: json['sku'] ?? 0,
      uid: json['uid'] ?? 1,
      clubId: json['club_id'] ?? 0,
      receiptId: json['receipt_id'] ?? '',
      price: json['price'] ?? 0,
      isMonthlyPaid: json['is_monthly_paid'] ?? false,
      updDate:
          (json['upd_date'] != null) ? DateTime.parse(json['upd_date']) : null,
    );
  }

  // PurchaseVo -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'uid': uid,
      'club_id': clubId,
      'receipt_id': receiptId,
      'price': price,
      'is_monthly_paid': isMonthlyPaid,
      'upd_date': updDate?.toIso8601String(),
    };
  }
}

//  API 요청을 처리하는 함수
class PurchaseService {
  static const String apiEndpoint = "http://13.125.197.66:18090/api/purchase";
  static final Dio dio = Dio();

  static Future<PurchaseVo?> fetchPurchaseData(PurchaseVo purchaseVo) async {
    final String url = "$apiEndpoint";

    print('📌 [API 요청 시작] 요청 URL: $url');

    try {
      final response = await dio.post(url, data: purchaseVo.toJson());

      print('✅ [API 응답 성공] 상태 코드: ${response.statusCode}');
      print('📩 [API 응답 데이터]: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        // If the server returns a single object:
        if (response.data is Map<String, dynamic>) {
          final parsedPurchase = PurchaseVo.fromJson(response.data);
          print('✅ [JSON 파싱 성공]');
          return parsedPurchase;
        }
        // If the server returns a list, handle that case:
        else if (response.data is List && response.data.isNotEmpty) {
          final parsedPurchase = PurchaseVo.fromJson(response.data[0]);
          return parsedPurchase;
        } else {
          print('⚠ [서버 응답 데이터가 비어있음]');
          return null;
        }
      } else {
        print('⚠ [서버 응답 이상] 코드: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('🚨 [API 요청 실패] 오류 발생: $e');
      return null;
    }
  }

  /// Optionally: fetch a list of purchases if your API returns an array
  static Future<List<PurchaseVo>> fetchAllPurchases() async {
    print('📌 [API 요청 시작] 모든 구매 내역 가져오기');
    try {
      final response = await dio.get(apiEndpoint);

      print('✅ [API 응답 성공] 상태 코드: ${response.statusCode}');
      print('📩 [API 응답 데이터]: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List) {
          // Parse each JSON object into PurchaseVo
          final List dataList = response.data;
          final List<PurchaseVo> purchaseList =
              dataList.map((item) => PurchaseVo.fromJson(item)).toList();
          return purchaseList;
        } else {
          print('⚠ [데이터가 배열 형식이 아님]');
          return [];
        }
      } else {
        print('⚠ [서버 응답 이상] 코드: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('🚨 [API 요청 실패] 오류 발생: $e');
      return [];
    }
  }
}
