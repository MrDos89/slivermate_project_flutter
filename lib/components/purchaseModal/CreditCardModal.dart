import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/pages/purchasePage.dart';
import 'package:slivermate_project_flutter/vo/lessonVo.dart';
import 'package:slivermate_project_flutter/vo/purchaseVo.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';

class CreditCardModal extends StatefulWidget {
  final UserVo dummyUser;
  final LessonVo lesson; // 상품 목록
  final PurchaseVo totalPurchases;
  final int totalPayment; // 총 결제금액

  const CreditCardModal({
    Key? key,
    required this.dummyUser,
    required this.lesson,
    required this.totalPurchases,
    required this.totalPayment,
  }) : super(key: key);

  @override
  _CreditCardModalState createState() => _CreditCardModalState();
}

class _CreditCardModalState extends State<CreditCardModal> {
  bool _cardInserted = false; // 카드 삽입 여부
  bool _paymentProcessing = false; // 결제 진행 여부
  bool _paymentCompleted = false; // 결제 완료 여부
  bool _acknowledged = false; // 결제 완료 후 안내 확인 여부

  /// 카드 삽입 + 결제 로딩 시뮬레이션
  Future<void> _simulateCardInsertion() async {
    // 이미 결제 중이거나 완료된 상태면 중복 실행 막기
    if (_paymentProcessing || _paymentCompleted) return;

    setState(() {
      _cardInserted = true;
      _paymentProcessing = true;
      _paymentCompleted = false;
      _acknowledged = false;
    });

    bool isSuccess = await PurchaseService.fetchPurchaseData(
      widget.totalPurchases,
    );

    if (isSuccess) {
      // 3초 동안 결제 로딩
      await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _paymentProcessing = false;
        _paymentCompleted = true;
      });

      // 결제 완료 안내 (모달은 자동으로 닫히지 않음)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("결제가 완료되었습니다. 단말기에서 카드를 빼주세요")),
      );

      Navigator.of(context).pushReplacementNamed(
        "/introduce",
        arguments: {
          "lessonCategory": widget.lesson.lessonCategory,
          "lessonSubCategory": widget.lesson.lessonSubCategory,
          "dummyUser": widget.dummyUser,
        },
      );
    }

    // ✅ 결제 정보 전송
    // Future<void> fetchPurchaseData() async {}
  }

  /// 카드의 최종 위치
  /// - 삽입 전: 키오스크 하단 밖
  /// - 결제 중: 더 깊이(마그네틱 부분이 완전히 안 보이도록)
  /// - 결제 완료 or 삽입 완료: 약간만 들어가 마그네틱 부분이 살짝 보이거나 거의 안 보이게
  double _getCardTopPosition(double kioskHeight) {
    // 아직 삽입되지 않은 상태
    if (!_cardInserted) {
      return kioskHeight + 40; // 화면 아래쪽
    }
    // 결제 진행 중(카드 상단 전혀 안 보이도록 좀 더 위로)
    if (_paymentProcessing) {
      return kioskHeight - 35; // 더 깊숙이
    }
    // 삽입 완료(결제 전) 또는 결제 완료 후
    return kioskHeight - 35; // 약간만 보이거나 거의 안 보이게
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // (1) 상단 타이틀
              Container(
                padding: const EdgeInsets.all(16),
                color: Color(0xFF044E00).withOpacity(0.5),
                width: double.infinity,
                child: const Text(
                  '신용카드 결제',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // (2) 상품 목록, 결제금액
              _buildTopSection(),
              // (3) 키오스크 + 카드 삽입 시뮬레이션
              _buildKioskSimulationSection(),
              // (4) 결제하기, 취소하기 버튼
              _buildBottomActions(context),
            ],
          ),
        ),
      ),
    );
  }

  /// (2) 상품 목록, 상품 제목, 총 결제금액
  Widget _buildTopSection() {
    final productListString = widget.lesson.lessonThumbnail;
    final productTitle = widget.lesson.lessonName ?? "상품 제목";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지
              Image.network(
                productListString,
                width: 105,
                height: 80,
                fit: BoxFit.fitHeight,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(width: 8),
              // 이미지 오른쪽에 제목과 총 결제금액 정보를 담은 Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목 (우측 상단에 위치)
                    Text(
                      productTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 총 결제금액 정보
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          '총 결제금액',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8), // 텍스트 사이의 간격 추가
                        Text(
                          '${widget.totalPayment}원',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
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

  /// (3) 키오스크 UI + 카드 삽입
  Widget _buildKioskSimulationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          Text(
            _paymentCompleted
                ? "결제가 완료되었습니다. 단말기에서 카드를 빼주세요"
                : "카드를 단말기에 삽입해주세요",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          _buildKioskUI(),
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

  /// (A) 키오스크 본체 + 어두운 슬롯 + 카드 삽입
  Widget _buildKioskUI() {
    final double kioskWidth = 200;
    final double kioskHeight = 280;

    final double cardLeft = (kioskWidth - 50) / 2;
    final double cardTop = _getCardTopPosition(kioskHeight) - 10;

    return GestureDetector(
      onTap: () {
        // 키오스크 탭 시 삽입
        if (!_cardInserted && !_paymentProcessing && !_paymentCompleted) {
          _simulateCardInsertion();
        }
      },
      child: SizedBox(
        width: kioskWidth,
        height: kioskHeight + 100, // 카드가 아래로 나올 공간
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // (1) 키오스크 본체
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: kioskWidth,
                height: kioskHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C8FA7),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // 스크린
                    Positioned(
                      top: 20,
                      left: (kioskWidth - 140) / 2,
                      child: Container(
                        width: 140,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB2C7D9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    // 하단 스탠드
                    Positioned(
                      bottom: 0,
                      left: (kioskWidth - 100) / 2,
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5B6E7D),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // (2) AnimatedPositioned 카드
            AnimatedPositioned(
              duration: const Duration(milliseconds: 2000), // 2초
              curve: Curves.easeInOut,
              left: cardLeft,
              top: cardTop,
              child: _buildCardWidget(),
            ),

            // (3) 어두운색 슬롯 (본체 하단부)
            //     카드가 뒤로 들어가서 상단이 안 보이도록
            //     이 사각형이 카드 위에 오므로, 카드 상단이 가려짐
            Positioned(
              // 슬롯을 본체 하단부에 맞춰서 배치
              top: kioskHeight - 50, // 하단 근처
              left: (kioskWidth - 80) / 2,
              child: Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A4A4A), // 어두운 색 (투명도 X)
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// (B) 세로 방향 카드 (노란색 마그네틱)
  Widget _buildCardWidget() {
    return GestureDetector(
      onTap: () {
        if (!_cardInserted && !_paymentProcessing && !_paymentCompleted) {
          _simulateCardInsertion();
        }
      },
      child: Container(
        width: 50,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // 상단 마그네틱 띠 (노란색, 중앙)
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  /// (4) 결제하기 / 취소하기
  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          // 결제하기 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF044E00).withOpacity(0.5),
                elevation: 0,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () async {
                // 아직 삽입 전이면 자동 삽입
                if (!_cardInserted) {
                  await _simulateCardInsertion();
                  return;
                }
                // 결제 중이면 안내
                if (_paymentProcessing) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("결제가 진행 중입니다. 잠시만 기다려주세요.")),
                  );
                  return;
                }
                // 이미 완료된 상태
                if (_paymentCompleted) {
                  if (!_acknowledged) {
                    setState(() {
                      _acknowledged = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "결제가 완료되었습니다. 단말기에서 카드를 빼주세요.\n버튼을 다시 누르면 창이 닫힙니다.",
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
              child: const Text(
                '결제하기',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 취소하기 버튼
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
              child: const Text(
                '취소하기',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
