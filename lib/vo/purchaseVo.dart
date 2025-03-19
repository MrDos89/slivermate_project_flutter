import 'package:dio/dio.dart';

class PurchaseVo {
  // final int id; //  결제 고유 아이디
  final int sku; //  결제 sku 아이디
  final int uid; //  결제한 유저 아이디
  final int lessonId;
  final int modelType; //   모델 타입 (moedelType)
  final int clubId; //  결제한 유저 소속 동아리
  final String receiptId; //  결제 승인증
  final int price; //  결제 가격
  final bool isMonthlyPaid; //  구독 모임인지 여부
  // final DateTime? updDate; //  업데이트 날짜 (nullable)

  PurchaseVo({
    // required this.id, //  필수 고유 아이디
    required this.sku, //  필수 결제 sku 아이디
    required this.uid, //  필수 결제한 유저 아이디
    required this.lessonId,
    required this.modelType, //    필수 결제 모델타입
    required this.clubId, //  필수 결제한 유저 소속 동아리
    required this.receiptId, // 필수 결제 승인증
    required this.price, //  필수 결제가격
    required this.isMonthlyPaid, //  필수 구독 모임인지 여부
    // this.updDate, // 필수 업데이트 날짜
  });

  //  JSON -> PurchaseVo 변환
  factory PurchaseVo.fromJson(Map<String, dynamic> json) {
    return PurchaseVo(
      // id: json['id'] ?? 0,
      sku: json['sku'] ?? 0,
      uid: json['uid'] ?? 1,
      lessonId: json['lesson_id'] ?? 0,
      modelType: json['modelType'] ?? 0,
      clubId: json['club_id'] ?? 0,
      receiptId: json['receipt_id'] ?? '',
      price: json['price'] ?? 0,
      isMonthlyPaid: json['is_monthly_paid'] ?? false,
      // updDate:
      // (json['upd_date'] != null) ? DateTime.parse(json['upd_date']) : null,
    );
  }

  // PurchaseVo -> JSON
  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'sku': sku,
      'uid': uid,
      'lesson_id': lessonId,
      'model_type': modelType,
      'club_id': clubId,
      'receipt_id': receiptId,
      'price': price,
      'is_monthly_paid': isMonthlyPaid,
      // 'upd_date': updDate?.toIso8601String(),
    };
  }
}

//  API 요청을 처리하는 함수
class PurchaseService {
  static const String apiEndPoint = "http://13.125.197.66:18090/api/purchase";
  static final Dio dio = Dio();

  static Future<bool> fetchPurchaseData(PurchaseVo purchaseVo) async {
    print('📌 [API 요청 시작] 요청 URL: $apiEndPoint');

    try {
      //  요청
      var dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      //  POST 요청
      final response = await dio.post(apiEndPoint, data: purchaseVo.toJson());

      //  응답
      if (response.statusCode == 200) {
        //  CREATED
        print("결제성공");

        return true;
      }
    } catch (e) {
      throw Exception("결제를 실패했습니다.:$e");
    }

    return false;
  }
}
