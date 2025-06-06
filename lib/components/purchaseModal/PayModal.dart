import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/pages/purchasePage.dart';
import 'package:slivermate_project_flutter/vo/lessonVo.dart';
import 'package:slivermate_project_flutter/vo/purchaseVo.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';

class PayModal extends StatefulWidget {
  final LessonVo lesson;
  final int modelType;
  // final int totalPayment;
  final UserVo userVo;

  const PayModal({
    Key? key,
    required this.userVo,
    required this.lesson,
    required this.modelType,
    // required this.totalPayment,
  }) : super(key: key);

  @override
  _PayModalState createState() => _PayModalState();
}

class _PayModalState extends State<PayModal> {
  bool _paymentProcessing = false;
  bool _paymentCompleted = false;

  /// purchaseVo 객체
  PurchaseVo get purchaseTotal {
    return PurchaseVo(
      sku: 0,
      uid: widget.userVo.uid,
      lessonId: widget.lesson.lessonId,
      modelType: widget.modelType,
      clubId: 0,
      receiptId: "test",
      price: widget.lesson.lessonPrice,
      isMonthlyPaid: false,
    );
  }

  /// 최종 결제 데이터 객체
  PurchaseVo get totalPurchases => purchaseTotal;

  Future<void> _simulatePayment() async {
    if (_paymentProcessing || _paymentCompleted) return;

    setState(() {
      _paymentProcessing = true;
      _paymentCompleted = false;
    });

    // 3초 동안 결제 로딩
    await Future.delayed(const Duration(seconds: 3));

    bool isSuccess = await PurchaseService.fetchPurchaseData(totalPurchases);

    if (isSuccess) {
      setState(() {
        _paymentProcessing = false;
        _paymentCompleted = true;
      });

      Navigator.of(context).pushReplacementNamed(
        "/introduce",
        arguments: {
          "lessonCategory": widget.lesson.lessonCategory,
          "lessonSubCategory": widget.lesson.lessonSubCategory,
          "userVo": widget.userVo,
        },
      );

      // 결제 완료 안내 (모달은 자동으로 닫히지 않음)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("결제가 완료되었습니다.")));
    }
  }

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
                color: Color(0xFF044E00).withOpacity(0.5),
                width: double.infinity,
                child: const Text(
                  '페이 결제',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                  textAlign: TextAlign.center,
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
            itemCount: 1,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(
                  widget.lesson.lessonThumbnail,
                  width: 105,
                  height: 80,
                  fit: BoxFit.cover,
                ),

                ///  임시아이콘
                title: Text(widget.lesson.lessonName),
                subtitle: Text('${widget.lesson.lessonPrice}원'),
              );
            },
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('총 결제금액', style: TextStyle(fontSize: 16)),
              Text(
                '${widget.lesson.lessonPrice}원',
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
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            tabs: [Tab(text: '페이'), Tab(text: 'QR코드')],
          ),
          Container(
            height: 200,
            child: TabBarView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('카카오페이 / 삼성페이 / 네이버페이 / 애플페이 결제'),
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
          backgroundColor: Color(0xFF044E00).withOpacity(0.5),
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
        ),
        onPressed: () {
          _simulatePayment();
        },
        child: const Text(
          '결제하기',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}
