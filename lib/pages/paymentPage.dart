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
  String? _selectedCardOrBank = null; // 카드사 및 은행 선택값
  bool _showList = false; // 카드사 및 은행 목록 표시 여부

  // 카드사 목록
  final List<String> cardList = [
    '비씨카드',
    '하나카드',
    '신한카드',
    'KB국민카드',
    '현대카드',
    'NH농협카드',
    '삼성카드',
    '롯데카드',
    '우리카드',
    '씨티카드',
    '기업BC카드',
  ];

  // 은행 목록
  final List<String> bankList = [
    '국민은행',
    '신한은행',
    '농협은행',
    'IBK기업은행',
    '외한은행',
    '하나은행',
    'KDB산업은행',
    'SC제일은행',
    '부산은행',
    '한국씨티은행',
    '새마을금고',
    '카카오뱅크',
    '토스뱅크',
  ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "결제"),
        ),
        body: SingleChildScrollView(
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
                        _selectedCardOrBank = null;
                        _showList = false; // Reset the dropdown
                      });
                    },
                  ),
                  if (_selectedPaymentMethod == 1) ...[
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showList = !_showList;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              _selectedCardOrBank ?? "[필수] 카드사를 선택해주세요",
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    if (_showList) ...[
                      ...cardList.map((card) {
                        return ListTile(
                          title: Text(card),
                          onTap: () {
                            setState(() {
                              _selectedCardOrBank = card;
                              _showList =
                                  false; // Hide the list after selection
                            });
                          },
                        );
                      }).toList(),
                      Divider(),
                      ...bankList.map((bank) {
                        return ListTile(
                          title: Text(bank),
                          onTap: () {
                            setState(() {
                              _selectedCardOrBank = bank;
                              _showList =
                                  false; // Hide the list after selection
                            });
                          },
                        );
                      }).toList(),
                    ],
                  ],
                  Divider(),
                  RadioListTile<int>(
                    title: const Text("카카오페이"),
                    value: 2,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                  Divider(),
                  RadioListTile<int>(
                    title: const Text("네이버페이"),
                    value: 3,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                  Divider(),
                  RadioListTile<int>(
                    title: const Text("토스페이"),
                    value: 4,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                  Divider(),
                  RadioListTile<int>(
                    title: const Text("애플페이"),
                    value: 5,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                  Divider(),
                  RadioListTile<int>(
                    title: const Text("휴대폰 결제"),
                    value: 6,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                ],
              ),
              // 결제금액, 프립금액, 수수료 표시
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("결제금액", style: TextStyle(fontSize: 23)),
                  Text("22,900원", style: TextStyle(fontSize: 23)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("회비", style: TextStyle(fontSize: 20)),
                  Text("22,900원", style: TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("수수료", style: TextStyle(fontSize: 20)),
                  Text("0원", style: TextStyle(fontSize: 20)),
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
                        vertical: 20,
                        horizontal: 60,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "결제하기",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                        vertical: 20,
                        horizontal: 60,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "취소하기",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
