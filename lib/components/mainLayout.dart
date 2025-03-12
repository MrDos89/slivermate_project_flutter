import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final bool showPaymentButton; // 결제 버튼 활성화 여부

  const MainLayout({
    super.key,
    required this.child,
    this.showPaymentButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, // 페이지 본문
      bottomNavigationBar: _buildFooter(context), // 공통 푸터 자동 포함
    );
  }

  // 📌 공통 푸터 위젯
  Widget _buildFooter(BuildContext context) {
    return Container(
      height: 70, // 높이 증가
      padding: const EdgeInsets.symmetric(vertical: 15), // 내부 패딩 증가
      decoration: const BoxDecoration(
        color: Color(0xFFE6E6FA), // 배경색 (어두운 회색)
        boxShadow: [
          // BoxShadow(
          //   color: Colors.black26,
          //   blurRadius: 4,
          //   spreadRadius: 1,
          //   offset: Offset(0, -2),
          // ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 🔙 뒤로가기 버튼
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.lightBlueAccent,
              size: 36,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          // 🏠 홈 버튼
          IconButton(
            icon: const Icon(
              Icons.home,
              color: Colors.lightBlueAccent,
              size: 36,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/");
            },
          ),
          // 💳 결제 버튼 (활성화 여부에 따라 다르게 표시)
          showPaymentButton
              ? IconButton(
                icon: const Icon(
                  Icons.payment,
                  color: Colors.lightBlueAccent,
                  size: 36,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/purchase");
                },
              )
              : const Opacity(
                opacity: 0.3, // ❌ 비활성화 시 투명도 낮춤
                child: Icon(Icons.payment, color: Colors.grey, size: 36),
              ),
        ],
      ),
    );
  }
}
