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
              // 탭 기능: [단말기 시뮬레이션], [수동 입력]
              _buildTabSection(),
              // 하단: 결제하기 버튼 (전체 결제 모달 종료)
              _buildBottomAction(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 상품 목록과 총 결제금액 표시
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

  /// 탭 기능: [단말기 시뮬레이션], [수동 입력]
  Widget _buildTabSection() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.pink,
            unselectedLabelColor: Colors.grey,
            tabs: [Tab(text: '단말기 시뮬레이션'), Tab(text: '수동 입력')],
          ),
          Container(
            height: 300, // 탭 콘텐츠 높이
            child: const TabBarView(
              children: [
                // 카드 단말기 시뮬레이션 탭
                CardTerminalSimulationWidget(),
                // 수동 입력 탭
                ManualEntryFormWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 하단의 결제하기 버튼 (모달 전체 종료)
  Widget _buildBottomAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          minimumSize: const Size(double.infinity, 48),
        ),
        onPressed: () {
          // 최종 결제 로직을 추가할 수 있습니다.
          Navigator.of(context).pop(); // 모달 닫기
        },
        child: const Text('결제하기', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

/// 카드 단말기 시뮬레이션 탭
class CardTerminalSimulationWidget extends StatefulWidget {
  const CardTerminalSimulationWidget({Key? key}) : super(key: key);

  @override
  _CardTerminalSimulationWidgetState createState() =>
      _CardTerminalSimulationWidgetState();
}

class _CardTerminalSimulationWidgetState
    extends State<CardTerminalSimulationWidget> {
  bool _cardInserted = false;
  bool _paymentProcessing = false;

  /// 카드 삽입 애니메이션 및 결제 진행 시뮬레이션
  void _simulateCardInsertion() {
    setState(() {
      _cardInserted = true;
      _paymentProcessing = true;
    });
    // 카드 삽입 후 2초 동안 결제 진행 애니메이션을 보여줌
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _paymentProcessing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _cardInserted ? "카드가 삽입되었습니다." : "카드를 단말기에 삽입해주세요.",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        // 카드 단말기 슬롯 영역
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            // AnimatedAlign로 카드 아이콘의 위치를 애니메이션 효과로 전환
            AnimatedAlign(
              alignment:
                  _cardInserted ? Alignment.center : const Alignment(-1.5, 0),
              duration: const Duration(seconds: 1),
              child: const Icon(
                Icons.credit_card,
                size: 40,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // 카드 삽입 전 버튼 및 삽입 후 상태에 따른 UI 변화
        !_cardInserted
            ? ElevatedButton(
              onPressed: _simulateCardInsertion,
              child: const Text("카드 삽입"),
            )
            : _paymentProcessing
            ? Column(
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("결제 진행 중..."),
              ],
            )
            : ElevatedButton(
              onPressed: () {
                // 결제 완료 후 처리 로직 (예: 결과 화면 전환)
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("카드 결제 완료되었습니다.")));
              },
              child: const Text("결제 완료"),
            ),
      ],
    );
  }
}

/// 수동 입력 탭: 카드 정보 입력 폼
class ManualEntryFormWidget extends StatefulWidget {
  const ManualEntryFormWidget({Key? key}) : super(key: key);

  @override
  _ManualEntryFormWidgetState createState() => _ManualEntryFormWidgetState();
}

class _ManualEntryFormWidgetState extends State<ManualEntryFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _processManualPayment() {
    if (_formKey.currentState!.validate()) {
      // 실제 결제 연동은 여기서 구현 (예: API 호출)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("수동 입력 결제 처리 중...")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 카드 번호 입력
            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: "카드 번호",
                hintText: "0000 0000 0000 0000",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "카드 번호를 입력하세요";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // 유효 기간 입력
            TextFormField(
              controller: _expiryDateController,
              decoration: const InputDecoration(
                labelText: "유효 기간",
                hintText: "MM/YY",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "유효 기간을 입력하세요";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // CVV 입력 (보안을 위해 마스킹)
            TextFormField(
              controller: _cvvController,
              decoration: const InputDecoration(
                labelText: "CVV",
                hintText: "•••",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "CVV를 입력하세요";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _processManualPayment,
              child: const Text("수동 결제"),
            ),
          ],
        ),
      ),
    );
  }
}
