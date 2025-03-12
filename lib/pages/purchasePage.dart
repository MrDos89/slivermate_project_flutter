import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';

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

  // 결제수단 분류
  final List<String> creditCards = [
    '국민카드',
    '신한카드',
    '농협카드',
    '현대카드',
    '삼성카드',
    '롯데카드',
  ];
  final List<String> checkCards = ['국민은행', '신한은행', '기업은행', '농협은행'];
  final List<String> pays = ['카카오페이', '삼성페이', '네이버페이', '애플페이'];
  final List<String> etc = ['QR코드 결제', '핸드폰 결제'];

  String? selectedPaymentMethod;

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

  /// 결제수단 선택
  void onPaymentMethodSelected(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });
  }

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
            // 실제 사용 시 imageUrl 무시
            imageUrl: 'https://via.placeholder.com/60',
          ),
        ];
      });
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
                // 결제수단
                _buildPaymentMethods(),
                const Divider(thickness: 1),
                // 가격 요약
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
          // 기존: Image.network(item.imageUrl)
          // 변경: Image.asset('lib/images/골프.jpg')
          leading: Image.asset(
            'lib/images/골프.jpg', // 임시 골프 이미지 등록
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

  Widget _buildPaymentMethods() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPaymentCategory('신용카드', creditCards),
          const SizedBox(height: 16),
          _buildPaymentCategory('체크카드', checkCards),
          const SizedBox(height: 16),
          _buildPaymentCategory('페이', pays),
          const SizedBox(height: 16),
          _buildPaymentCategory('기타', etc),
        ],
      ),
    );
  }

  Widget _buildPaymentCategory(String title, List<String> methods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              methods.map((method) {
                final isSelected = (selectedPaymentMethod == method);
                return GestureDetector(
                  onTap: () => onPaymentMethodSelected(method),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pink[50] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.pink : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      method,
                      style: TextStyle(
                        color: isSelected ? Colors.pink : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          _buildRowItem('총 상품금액', '$itemsTotal원'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '총 결제예상금액',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '$totalPayment원',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label), Text(value)],
    );
  }
}
