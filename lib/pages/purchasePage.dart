import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
// 모달 파일들 임포트
import 'package:slivermate_project_flutter/components/purchaseModal/CreditCardModal.dart';
import 'package:slivermate_project_flutter/components/purchaseModal/PayModal.dart';
import 'package:slivermate_project_flutter/components/purchaseModal/EtcModal.dart';

/// 강의 영상(또는 상품) 데이터 모델
class CartItem {
  String name;
  int price;
  int quantity;
  String imageUrl;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'] ?? 1,
      imageUrl: json['imageUrl'],
    );
  }
}

class PurchasePage extends StatefulWidget {
  const PurchasePage({Key? key}) : super(key: key);

  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  List<CartItem> cartItems = []; // 선택한 강의 영상 데이터

  /// 장바구니 총합
  int get itemsTotal {
    int sum = 0;
    for (var item in cartItems) {
      sum += item.price * item.quantity;
    }
    return sum;
  }

  /// 최종 결제금액
  int get totalPayment => itemsTotal;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // IntroducePage에서 넘어온 데이터 확인
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      final selectedLecture = CartItem.fromJson(args);
      setState(() {
        cartItems = [selectedLecture];
      });
    } else {
      // 테스트용 기본 데이터
      setState(() {
        cartItems = [
          CartItem(
            name: '골프 강의 영상',
            price: 18000,
            quantity: 1,
            imageUrl: 'https://via.placeholder.com/60',
          ),
        ];
      });
    }
  }

  /// 결제수단 4가지
  final List<_PaymentMethod> paymentMethods = [
    _PaymentMethod(
      label: '카드 결제',
      icon: Icons.credit_card,
      modalType: _ModalType.card,
    ),
    _PaymentMethod(
      label: '페이 결제',
      icon: Icons.payment,
      modalType: _ModalType.pay,
    ),
    _PaymentMethod(
      label: '핸드폰 결제',
      icon: Icons.phone_android,
      modalType: _ModalType.phone,
    ),
    _PaymentMethod(
      label: 'QR 결제',
      icon: Icons.qr_code,
      modalType: _ModalType.qr,
    ),
  ];

  /// 결제수단 선택 시 모달 띄우기
  void _onPaymentMethodSelected(_ModalType type) {
    switch (type) {
      case _ModalType.card:
        showDialog(
          context: context,
          builder:
              (context) => CreditCardModal(
                cartItems: cartItems,
                totalPayment: totalPayment,
              ),
        );
        break;
      case _ModalType.pay:
        showDialog(
          context: context,
          builder:
              (context) =>
                  PayModal(cartItems: cartItems, totalPayment: totalPayment),
        );
        break;
      case _ModalType.phone:
      case _ModalType.qr:
        // phone, qr 등은 EtcModal 재활용 예시
        showDialog(
          context: context,
          builder:
              (context) =>
                  EtcModal(cartItems: cartItems, totalPayment: totalPayment),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: AppBar(
          leading: null, // 뒤로가기 버튼 제거
          automaticallyImplyLeading: false,
          title: const Text('결제화면'),
          centerTitle: true,
          backgroundColor: Colors.pink,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                // 상품 목록
                _buildCartList(),
                const Divider(thickness: 1),
                // 결제수단 (2번째 사진처럼 아이콘 + 라벨 4개)
                _buildPaymentOptions(),
                const Divider(thickness: 1),
                // 가격 요약 (텍스트 크기 키움)
                _buildPriceSummary(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 상품 목록 (수량 조절 제거)
  Widget _buildCartList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return ListTile(
          leading: Image.asset(
            'lib/images/골프.jpg', // 임시 골프 이미지
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          title: Text(item.name, style: const TextStyle(fontSize: 16)),
          subtitle: Text('${item.price}원'),
        );
      },
    );
  }

  /// 4가지 결제수단을 아이콘+텍스트 큰 버튼으로 표현
  Widget _buildPaymentOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // 상단 안내 문구
          const Text(
            '결제수단을 선택해 주세요',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // 2x2 Grid 형태로 4개 버튼
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.1, // 아이콘+텍스트 비율
            children:
                paymentMethods.map((method) {
                  return GestureDetector(
                    onTap: () => _onPaymentMethodSelected(method.modalType),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(method.icon, size: 48, color: Colors.black54),
                          const SizedBox(height: 8),
                          Text(
                            method.label,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  /// 가격 요약 (텍스트 크기 키워서 2번째 그림 느낌)
  Widget _buildPriceSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          // "총 상품금액" (일반 크기)
          _buildRowItem(
            '총 상품금액',
            '${itemsTotal}원',
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          const SizedBox(height: 8),
          // "총 결제예상금액" (크게)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '총 결제금액',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '$totalPayment원',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem(
    String label,
    String value, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
        Text(
          value,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
      ],
    );
  }
}

/// 결제수단 종류 구분
enum _ModalType { card, pay, phone, qr }

/// 결제수단 데이터 모델
class _PaymentMethod {
  final String label;
  final IconData icon;
  final _ModalType modalType;

  _PaymentMethod({
    required this.label,
    required this.icon,
    required this.modalType,
  });
}
