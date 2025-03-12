import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';

/// 장바구니 아이템 예시용 클래스
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
}

class PurchasePage extends StatefulWidget {
  const PurchasePage({Key? key}) : super(key: key);

  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  // 예시 상품 목록
  final List<CartItem> cartItems = [
    CartItem(
      name: '골프 강의 영상',
      price: 18000,
      quantity: 1,
      imageUrl: 'https://via.placeholder.com/60', // 썸넬 이미지 or 썸넬 영상
    ),
  ];

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

  // 선택된 결제수단
  String? selectedPaymentMethod;

  /// 장바구니 총합
  int get itemsTotal {
    int sum = 0;
    for (var item in cartItems) {
      sum += item.price * item.quantity;
    }
    return sum;
  }

  /// 최종 결제금액 (배송비가 없다면 itemsTotal만 사용)
  int get totalPayment => itemsTotal;

  /// 결제수단을 선택했을 때
  void onPaymentMethodSelected(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      // 🔹 MainLayout 적용 (푸터 추가됨)
      child: Scaffold(
        // 상단 AppBar
        appBar: AppBar(
          title: const Text('결제화면'),
          centerTitle: true,
          backgroundColor: Colors.pink,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // 메인 내용: 스크롤 가능 영역
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [
                    // 상품 목록 + 수량 조절
                    _buildCartList(),
                    const Divider(thickness: 1),
                    // 가격 요약
                    _buildPriceSummary(),
                    const Divider(thickness: 1),
                    // 결제수단 선택
                    _buildPaymentMethods(),
                  ],
                ),
              ),
              // 하단 고정: 총 결제금액 버튼
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomBar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 장바구니 상품 목록
  Widget _buildCartList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return ListTile(
          leading: Image.network(item.imageUrl, width: 60, height: 60),
          title: Text(item.name, style: const TextStyle(fontSize: 16)),
          subtitle: Text('${item.price}원'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (item.quantity > 1) {
                      item.quantity--;
                    }
                  });
                },
              ),
              Text('${item.quantity}'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    item.quantity++;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 가격 요약: 상품 합계, 총 결제금액
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

  /// 결제수단 목록
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
          _buildPaymentCategory('기타', etc), // QR, 핸드폰 결제
        ],
      ),
    );
  }

  /// 결제수단을 카드형식으로 보여주는 함수
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

  /// 하단: 총 결제금액 & 결제 버튼
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // 총 결제금액
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '총 결제금액',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalPayment원',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // 결제하기 버튼
          ElevatedButton(
            onPressed: () {
              if (selectedPaymentMethod == null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('결제수단을 선택해주세요.')));
                return;
              }
              // 실제 결제 로직 추가
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '[$selectedPaymentMethod]로 결제 진행 (${totalPayment}원)',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              '총 ${totalPayment}원 결제하기',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// (레이블, 값) 한 줄 표시
  Widget _buildRowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label), Text(value)],
    );
  }
}
