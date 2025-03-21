import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
// 모달 파일들
import 'package:slivermate_project_flutter/components/purchaseModal/CreditCardModal.dart';
import 'package:slivermate_project_flutter/components/purchaseModal/PayModal.dart';
import 'package:slivermate_project_flutter/components/purchaseModal/EtcModal.dart';
// Lottie
import 'package:lottie/lottie.dart';

import 'package:slivermate_project_flutter/vo/lessonVo.dart';
import 'package:slivermate_project_flutter/vo/purchaseVo.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';

/// 결제수단 타입
enum _ModalType { card, pay, phone, qr }

/// 결제수단 데이터 모델
class _PaymentMethod {
  final String label;
  final String? lottieAssetPath;
  final _ModalType modalType;

  _PaymentMethod({
    required this.label,
    this.lottieAssetPath,
    required this.modalType,
  });
}

class PurchasePage extends StatefulWidget {
  final UserVo? dummyUser;
  const PurchasePage({super.key, required this.dummyUser});

  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  late LessonVo lesson;
  late PurchaseVo purchase;

  @override
  void initState() {
    super.initState();
    print(
      "🟢 [PurchasePage initState()] dummyUser 값: ${widget.dummyUser?.userName}, ${widget.dummyUser?.email}",
    );
    // fetchPurchaseData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    print("purchasePage didChangeDependencies의 args: ${args.toString()}");

    if (args != null && args is Map) {
      final lessonArgs = args["lesson"];
      if (lessonArgs != null && lessonArgs is LessonVo) {
        setState(() {
          lesson = lessonArgs;
        });
      } else {
        // 테스트용 기본 데이터
        setState(() {
          this.lesson = LessonVo(
            lessonId: 1,
            userId: 1,
            lessonName: 'test',
            lessonDesc: 'test',
            lessonCostDesc: 'test',
            lessonCategory: 1,
            lessonSubCategory: 1,
            lessonFreeLecture: "test",
            lessonCostLecture: 'test',
            lessonThumbnail: 'https://via.placeholder.com/60',
            lessonPrice: 18000,
            registerDate: "2025-03-18",
            isHidden: false,
            updDate: '골프 강의 영상',
            userName: "test",
            userThumbnail: "test",
          );
        });
      }
    }
  }

  /// 결제수단 4가지
  final List<_PaymentMethod> paymentMethods = [
    _PaymentMethod(
      label: '카드 결제',
      lottieAssetPath: 'lib/animations/credit_card.json',
      modalType: _ModalType.card,
    ),
    _PaymentMethod(
      label: '페이 결제',
      lottieAssetPath: 'lib/animations/pay_card.json',
      modalType: _ModalType.pay,
    ),
    _PaymentMethod(
      label: '핸드폰 결제',
      lottieAssetPath: 'lib/animations/phone_pay.json',
      modalType: _ModalType.phone,
    ),
    _PaymentMethod(
      label: 'QR 결제',
      lottieAssetPath: 'lib/animations/qr_scan.json',
      modalType: _ModalType.qr,
    ),
  ];

  /// 결제수단 선택 시 모달 띄우기
  void _openModal(_ModalType type) {
    switch (type) {
      case _ModalType.card:
        showDialog(
          context: context,
          builder:
              (_) => CreditCardModal(
                dummyUser: widget.dummyUser!,
                lesson: lesson,
                modelType: 1,
                // totalPayment: totalPayment,
              ),
        );
        break;
      case _ModalType.pay:
        showDialog(
          context: context,
          builder:
              (_) => PayModal(
                dummyUser: widget.dummyUser!,
                lesson: lesson,
                modelType: 2,
                // totalPayment: totalPayment,
              ),
        );
        break;
      case _ModalType.phone:
        showDialog(
          context: context,
          builder:
              (_) => EtcModal(
                dummyUser: widget.dummyUser!,
                lesson: lesson,
                modelType: 3,
                // totalPayment: totalPayment,
              ),
        );
      case _ModalType.qr:
        showDialog(
          context: context,
          builder:
              (_) => EtcModal(
                dummyUser: widget.dummyUser!,
                lesson: lesson,
                modelType: 4,
                // totalPayment: totalPayment,
              ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      dummyUser: widget.dummyUser,
      child: Scaffold(
        appBar: AppBar(
          leading: null, //  뒤로가기 버튼 지우기
          automaticallyImplyLeading: false,
          centerTitle: false, //  제목을 왼쪽 정렬로 유지
          title: Transform.translate(
            offset: const Offset(0, 8),
            child: const Text(
              "결제화면",
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Color(0xFF044E00).withOpacity(0.5),
          elevation: 0,
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            // Extra bottom padding so the price summary isn't cut off
            padding: const EdgeInsets.only(top: 16, bottom: 60),
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

  /// (1) 상품 목록
  Widget _buildCartList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 1,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(
            lesson.lessonThumbnail,
            width: 105,
            height: 80,
            fit: BoxFit.cover,
          ),
          title: Text(lesson.lessonName, style: const TextStyle(fontSize: 16)),
          subtitle: Text('${lesson.lessonPrice}원'),
        );
      },
    );
  }

  /// (2) 결제수단 Grid
  Widget _buildPaymentOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          const Text(
            '결제수단을 선택해 주세요',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF077A00),
            ),
          ),
          const SizedBox(height: 16),
          // Grid of Lottie animations
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            // Give even more vertical space
            childAspectRatio: 0.7,
            children:
                paymentMethods.map((method) {
                  return InkWell(
                    onTap: () => {_openModal(method.modalType)},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Slightly smaller Lottie for safe spacing
                          SizedBox(
                            width: 100,
                            height: 100,
                            child:
                                method.lottieAssetPath != null
                                    ? Lottie.asset(method.lottieAssetPath!)
                                    : const Icon(
                                      Icons.warning,
                                      size: 60,
                                      color: Colors.red,
                                    ),
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
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  /// (3) 가격 요약
  Widget _buildPriceSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '총 상품금액',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF077A00),
                ),
              ),
              Text(
                '${lesson.lessonPrice}원',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '총 결제금액',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF077A00),
                ),
              ),
              Text(
                '${lesson.lessonPrice}원',
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
