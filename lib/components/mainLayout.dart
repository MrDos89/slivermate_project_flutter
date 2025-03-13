import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/pages/CallStaffPage.dart';

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
          // 🔔 직원 호출 버튼 (아이콘 변경)
          IconButton(
            icon: const Icon(
              Icons.person_pin,
              // Icons.support_agent,
              // Icons.badge,
              // Icons.emoji_people,
              color: Colors.lightBlueAccent,
              size: 36,
            ),
            onPressed: () {
              // TODO: 직원 호출 기능 추가
              // print("직원 호출됨");
              // Navigator.pushNamed(context, "/call"); // ✅ 직원 호출 페이지로 이동
              _showStaffCallModal(context); // ✅ 모달 호출
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

// 디버깅
// import 'package:flutter/material.dart';
//
// class MainLayout extends StatelessWidget {
//   final Widget child;
//   final bool showPaymentButton; // 결제 버튼 활성화 여부
//   final bool showAlertButton; // 알림 버튼 활성화 여부
//
//   const MainLayout({
//     super.key,
//     required this.child,
//     this.showPaymentButton = false,
//     this.showAlertButton = true, // 기본값 false
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: child, // 페이지 본문
//       bottomNavigationBar: _buildFooter(context), // 공통 푸터 자동 포함
//     );
//   }
//
//   // 📌 공통 푸터 위젯
//   Widget _buildFooter(BuildContext context) {
//     return Container(
//       height: 70, // 높이 증가
//       padding: const EdgeInsets.symmetric(vertical: 15), // 내부 패딩 증가
//       decoration: const BoxDecoration(
//         color: Color(0xFFE6E6FA), // 배경색 (어두운 회색)
//         boxShadow: [
//           // BoxShadow(
//           //   color: Colors.black26,
//           //   blurRadius: 4,
//           //   spreadRadius: 1,
//           //   offset: Offset(0, -2),
//           // ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           // 🔙 뒤로가기 버튼
//           IconButton(
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.lightBlueAccent,
//               size: 36,
//             ),
//             onPressed: () {
//               if (Navigator.canPop(context)) {
//                 Navigator.pop(context);
//               }
//             },
//           ),
//           // 🏠 홈 버튼 or 🔔 알림 버튼 (디버그 환경)
//           showAlertButton
//               ? IconButton(
//             icon: const Icon(
//               Icons.notifications,
//               color: Colors.redAccent,
//               size: 36,
//             ),
//             onPressed: () {
//               debugPrint("🔔 알림 버튼 클릭됨! (디버그)");
//             },
//           )
//               : IconButton(
//             icon: const Icon(
//               Icons.home,
//               color: Colors.lightBlueAccent,
//               size: 36,
//             ),
//             onPressed: () {
//               Navigator.pushNamed(context, "/");
//             },
//           ),
//           // 💳 결제 버튼 (활성화 여부에 따라 다르게 표시)
//           showPaymentButton
//               ? IconButton(
//             icon: const Icon(
//               Icons.payment,
//               color: Colors.lightBlueAccent,
//               size: 36,
//             ),
//             onPressed: () {
//               Navigator.pushNamed(context, "/purchase");
//             },
//           )
//               : const Opacity(
//             opacity: 0.3, // ❌ 비활성화 시 투명도 낮춤
//             child: Icon(Icons.payment, color: Colors.grey, size: 36),
//           ),
//         ],
//       ),
//     );
//   }
// }
