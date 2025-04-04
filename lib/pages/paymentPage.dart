import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int? _selectedPaymentMethod = 0; // 결제 수단의 기본 선택값

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "결제"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 파릇 정보
              Text(
                "파릇 정보",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('lib/images/당구.jpg'), // 썸네일 이미지
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "초보자도 완등할 수 있는 청계산 정복",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(), // 구분선 추가
              // 일정 정보
              const SizedBox(height: 10),
              Text(
                "일정 정보",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("4월 05일 (토) 오후 3:00", style: TextStyle(fontSize: 14)),
              const SizedBox(height: 10),

              Divider(), // 구분선 추가
              // 결제 수단
              const SizedBox(height: 10),
              Text(
                "결제수단",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  RadioListTile<int>(
                    title: const Text("신용/체크카드"),
                    value: 1,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    secondary: Icon(Icons.credit_card),
                  ),
                  RadioListTile<int>(
                    title: const Text("카카오페이"),
                    value: 2,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    secondary: Icon(Icons.payment),
                  ),
                  RadioListTile<int>(
                    title: const Text("애플페이"),
                    value: 3,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    secondary: Icon(Icons.apple),
                  ),
                  RadioListTile<int>(
                    title: const Text("휴대폰 결제"),
                    value: 4,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    secondary: Icon(Icons.phone_iphone),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 결제금액, 프립금액, 수수료 표시
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("결제금액", style: TextStyle(fontSize: 16)),
                  Text("22,900원", style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("수수료", style: TextStyle(fontSize: 16)),
                  Text("0원", style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 20),

              // 결제하기 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // 결제하기 버튼 클릭 시 처리 로직
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 30,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "결제하기",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),

                  // 취소하기 버튼
                  GestureDetector(
                    onTap: () {
                      // 취소하기 버튼 클릭 시 처리 로직
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 30,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "취소하기",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
