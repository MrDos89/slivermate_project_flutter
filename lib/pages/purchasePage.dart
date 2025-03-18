import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';

// 모달 파일들
import 'package:slivermate_project_flutter/components/purchaseModal/CreditCardModal.dart';
import 'package:slivermate_project_flutter/components/purchaseModal/PayModal.dart';
import 'package:slivermate_project_flutter/components/purchaseModal/EtcModal.dart';
// MP4 아이콘
import 'package:slivermate_project_flutter/components/purchaseModal/AnimatedMp4Icon.dart';

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
  List<CartItem> cartItems = [];

  int get itemsTotal {
    int sum = 0;
    for (var item in cartItems) {
      sum += item.price * item.quantity;
    }
    return sum;
  }

  int get totalPayment => itemsTotal;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      final selectedLecture = CartItem.fromJson(args);
      setState(() {
        cartItems = [selectedLecture];
      });
    } else {
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
  /// - 카드 결제, 페이 결제, 핸드폰 결제, QR 결제 모두 MP4 동영상 사용
  final List<_PaymentMethod> paymentMethods = [
    _PaymentMethod(
      label: '카드 결제',
      mp4AssetPath: 'lib/videos/credit_card.mp4',
      icon: null,
      modalType: _ModalType.card,
    ),
    _PaymentMethod(
      label: '페이 결제',
      mp4AssetPath: 'lib/videos/pay_card.mp4',
      icon: null,
      modalType: _ModalType.pay,
    ),
    _PaymentMethod(
      label: '핸드폰 결제',
      mp4AssetPath: 'lib/videos/phone_pay.mp4', // 핸드폰 결제 동영상
      icon: null,
      modalType: _ModalType.phone,
    ),
    _PaymentMethod(
      label: 'QR 결제',
      mp4AssetPath: 'lib/videos/qr_scan.mp4',
      icon: null,
      modalType: _ModalType.qr,
    ),
  ];

  /// 결제수단별 모달 열기
  void _openModal(_ModalType type) {
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
          leading: null,
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
                _buildCartList(),
                const Divider(thickness: 1),
                _buildPaymentOptions(),
                const Divider(thickness: 1),
                _buildPriceSummary(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return ListTile(
          leading: Image.asset(
            'lib/images/골프.jpg',
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

  /// 결제수단 버튼 (동영상은 자동 재생, 탭하면 모달 열기)
  Widget _buildPaymentOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          const Text(
            '결제수단을 선택해 주세요',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.1,
            children:
                paymentMethods.map((method) {
                  return Container(
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
                        AnimatedMp4Icon(
                          assetPath: method.mp4AssetPath!,
                          width: 120,
                          height: 120,
                          onTap: () => _openModal(method.modalType),
                        ),
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
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          _buildRowItem(
            '총 상품금액',
            '${itemsTotal}원',
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
          const SizedBox(height: 8),
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
                  fontSize: 35,
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

enum _ModalType { card, pay, phone, qr }

class _PaymentMethod {
  final String label;
  final IconData? icon; // null이면 mp4 사용
  final String? mp4AssetPath; // null이면 icon 사용
  final _ModalType modalType;

  _PaymentMethod({
    required this.label,
    this.icon,
    this.mp4AssetPath,
    required this.modalType,
  });
}
