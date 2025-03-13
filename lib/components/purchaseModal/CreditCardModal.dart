import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/pages/purchasePage.dart';

class CreditCardModal extends StatefulWidget {
  final List<CartItem> cartItems; // 상품 목록
  final int totalPayment; // 총 결제금액

  const CreditCardModal({
    Key? key,
    required this.cartItems,
    required this.totalPayment,
  }) : super(key: key);

  @override
  _CreditCardModalState createState() => _CreditCardModalState();
}

class _CreditCardModalState extends State<CreditCardModal> {
  bool _cardInserted = false; // 카드 삽입 여부
  bool _paymentProcessing = false; // 결제 진행 여부
  bool _paymentCompleted = false; // 결제 완료 여부
  bool _acknowledged = false; // 결제 완료 후 안내를 받았는지 여부

  /// 카드 삽입 애니메이션 및 결제 진행 시뮬레이션 (3초)
  Future<void> _simulateCardInsertion() async {
    if (_paymentProcessing || _paymentCompleted) return;

    setState(() {
      _cardInserted = true;
      _paymentProcessing = true;
      _paymentCompleted = false;
      _acknowledged = false;
    });

    // 3초 동안 결제 진행 애니메이션(로딩) 실행
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _paymentProcessing = false;
      _paymentCompleted = true;
    });

    // 결제 완료 안내 메시지 (모달은 바로 닫히지 않음)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("결제가 완료되었습니다. 단말기에서 카드를 빼주세요")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // 내용에 맞춰 높이 조절
            children: [
              // (1) 상단 타이틀 영역
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.pink,
                width: double.infinity,
                child: const Text(
                  '신용카드 결제',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              // (2) 상단: 상품 목록(왼쪽) + 상품 제목(오른쪽) + 총 결제금액 + 구분선
              _buildTopSection(),
              // (3) 카드 단말기 시뮬레이션 영역
              _buildCardSimulationSection(),
              // (4) 하단 버튼: 결제하기, 취소하기
              _buildBottomActions(context),
            ],
          ),
        ),
      ),
    );
  }

  /// (2) 상단 영역: 상품 목록, 상품 제목, 총 결제금액, 구분선 표시
  Widget _buildTopSection() {
    final productListString = widget.cartItems
        .map((item) => item.name)
        .join(', ');
    final productTitle =
        widget.cartItems.isNotEmpty ? widget.cartItems[0].name : "상품 제목";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 왼쪽: 상품 목록
              Expanded(
                child: Text(
                  productListString.isNotEmpty
                      ? productListString
                      : "상품 목록이 없습니다.",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              // 오른쪽: 상품 제목
              Text(
                productTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '총 결제금액',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                '${widget.totalPayment}원',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }

  /// (3) 카드 단말기 시뮬레이션 영역
  Widget _buildCardSimulationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        children: [
          // 안내 문구: 결제 전/완료 상태에 따라 변경
          Text(
            _paymentCompleted
                ? "결제가 완료되었습니다. 단말기에서 카드를 빼주세요"
                : "카드를 단말기에 삽입해주세요",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          // 단말기 슬롯(네모칸) 및 카드 아이콘 (두 군데 모두 탭하면 시뮬레이션 실행)
          _buildCardSlotWidget(),
          // 결제 진행 중이면 로딩 및 안내 표시
          if (_paymentProcessing) ...[
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
            const SizedBox(height: 8),
            const Text("결제 진행 중..."),
          ],
        ],
      ),
    );
  }

  /// (A) 단말기 슬롯(네모칸)와 카드 아이콘 (슬롯 전체에 GestureDetector 적용)
  Widget _buildCardSlotWidget() {
    return Center(
      child: GestureDetector(
        onTap: () {
          if (!_cardInserted && !_paymentProcessing && !_paymentCompleted) {
            _simulateCardInsertion();
          }
        },
        child: SizedBox(
          width: 200,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 네모칸 슬롯
              Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // 카드 아이콘 (AnimatedAlign 이동 효과)
              AnimatedAlign(
                duration: const Duration(milliseconds: 500),
                alignment:
                    _cardInserted ? Alignment.center : const Alignment(-1.5, 0),
                child: Icon(Icons.credit_card, size: 40, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// (4) 하단 액션 버튼: 결제하기, 취소하기
  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        children: [
          // 결제하기 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () async {
                // 카드가 아직 삽입되지 않았다면 시뮬레이션 실행
                if (!_cardInserted) {
                  await _simulateCardInsertion();
                  return;
                }
                // 결제 진행 중이면 안내 후 종료
                if (_paymentProcessing) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("결제가 진행 중입니다. 잠시만 기다려주세요.")),
                  );
                  return;
                }
                // 결제가 완료된 상태
                if (_paymentCompleted) {
                  if (!_acknowledged) {
                    setState(() {
                      _acknowledged = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "결제가 완료되었습니다. 단말기에서 카드를 빼주세요. 버튼을 다시 누르면 창이 닫힙니다.",
                        ),
                      ),
                    );
                    return;
                  } else {
                    Navigator.of(context).pop();
                    return;
                  }
                }
              },
              child: const Text('결제하기', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
          // 취소하기 버튼 (누르면 바로 모달창 닫힘)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소하기', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
