import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/pages/purchasePage.dart';

class CreditCardModal extends StatelessWidget {
  final List<CartItem> cartItems; // 상품 목록
  final int totalPayment; // 총 결제금액

  const CreditCardModal({
    Key? key,
    required this.cartItems,
    required this.totalPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // AlertDialog 대신 Dialog를 사용 (모달)
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 상단 타이틀
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.pink,
                width: double.infinity,
                child: const Text(
                  '신용카드 결제',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),

              // 상품 목록 & 결제금액
              _buildCartListSection(),

              // 탭 기능 (예: [카드입력], [QR코드])
              _buildTabSection(),

              // 결제하기 버튼
              _buildBottomAction(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 상단: 상품 목록과 총 결제금액
  Widget _buildCartListSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 상품 목록
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: Text(item.name),
                subtitle: Text('${item.price}원'),
              );
            },
          ),
          const Divider(),
          // 총 결제금액
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('총 결제금액', style: TextStyle(fontSize: 16)),
              Text(
                '$totalPayment원',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 탭 기능: [카드입력], [QR코드] 등
  Widget _buildTabSection() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.pink,
            unselectedLabelColor: Colors.grey,
            tabs: [Tab(text: '카드입력'), Tab(text: 'QR코드')],
          ),
          Container(
            height: 200, // 탭 콘텐츠 높이
            child: TabBarView(
              children: [
                // [카드입력] 탭
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('신용카드 정보 입력 폼 (예: 카드번호, 유효기간 등)'),
                  ),
                ),
                // [QR코드] 탭
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.qr_code, size: 64, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('QR코드를 스캔하세요'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 하단: 결제하기 버튼
  Widget _buildBottomAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          minimumSize: const Size(double.infinity, 48),
        ),
        onPressed: () {
          // 결제 로직
          Navigator.of(context).pop(); // 모달 닫기
        },
        child: const Text('결제하기', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
