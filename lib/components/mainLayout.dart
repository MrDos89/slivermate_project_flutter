import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/pages/CallStaffPage.dart';
import 'package:slivermate_project_flutter/vo/lessonVo.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final bool showPaymentButton; // 결제 버튼 활성화 여부
  final bool showAlertButton; // 디버그 상태에서 알림 버튼 활성화 여부
  final LessonVo? lesson;

  const MainLayout({
    super.key,
    required this.child,
    this.showPaymentButton = false,
    this.showAlertButton = false,
    this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, // 페이지 본문
      bottomNavigationBar: _buildFooter(context), // 공통 푸터 자동 포함
    );
  }

  void _showStaffCallModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ❌ 바깥 클릭으로 닫히지 않도록 설정
      builder: (BuildContext context) {
        return const CallStaffPage(); // ✅ 수정된 CallStaffPage 사용 (오류 해결)
      },
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
          //  직원 호출 버튼 or  알림 버튼 (디버그 상태에 따라 변경)
          IconButton(
            icon: Icon(
              showAlertButton ? Icons.notifications : Icons.person_pin,
              color:
                  showAlertButton ? Colors.redAccent : Colors.lightBlueAccent,
              size: 36,
            ),
            onPressed: () {
              if (showAlertButton) {
                // debugPrint("🔔 알림 버튼 클릭됨! (디버그)");
                Navigator.pushNamed(context, "/notifications"); // 🔔 알림 페이지로 이동
              } else {
                _showStaffCallModal(context); // ✅ 직원 호출 모달 띄우기
              }
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
                  if (lesson != null) {
                    // ✅ lesson이 null이 아닐 때만 이동
                    Navigator.pushNamed(
                      context,
                      "/purchase",
                      arguments: lesson,
                    );
                  } else {
                    print("🚨 [오류] lesson 데이터가 없습니다! 결제 페이지로 이동할 수 없음.");
                  }
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
