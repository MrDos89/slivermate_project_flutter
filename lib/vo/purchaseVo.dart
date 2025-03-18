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

  static Future<PurchaseVo?> fetchPurchaseData(
      int
      )
}
