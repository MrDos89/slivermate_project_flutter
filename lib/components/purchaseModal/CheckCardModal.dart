import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/pages/purchasePage.dart';

class CheckCardModal extends StatelessWidget {
  final List<CartItem> cartItems;
  final int totalPayment;

  const CheckCardModal({
    Key? key,
    required this.cartItems,
    required this.totalPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 상단 타이틀
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue,
                width: double.infinity,
                child: const Text(
                  '체크카드 결제',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),

              // 상품 목록 & 결제금액
              _buildCartListSection(),

              // 탭 기능
              _buildTabSection(),

              // 결제하기 버튼
              _buildBottomAction(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartListSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return ListTile(
                leading: const Icon(Icons.shopping_cart),

                /// 임시 아이콘
                title: Text(item.name),
                subtitle: Text('${item.price}원'),
              );
            },
          ),
          const Divider(),
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

  Widget _buildTabSection() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [Tab(text: '체크카드 입력'), Tab(text: 'QR코드')],
          ),
          Container(
            height: 200,
            child: TabBarView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('체크카드 정보 입력 폼 (예: 은행명, 계좌번호 등)'),
                  ),
                ),
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

  Widget _buildBottomAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: const Size(double.infinity, 48),
        ),
        onPressed: () {
          // 결제 로직
          Navigator.of(context).pop();
        },
        child: const Text('결제하기', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
