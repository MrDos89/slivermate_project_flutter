import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(),
          // child: Container(
          //   height: 70,
          //   color: Colors.transparent,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       // 왼쪽: 뒤로가기 버튼과 "채팅페이지" 텍스트를 Row로 묶음
          //       Row(
          //         children: [
          //           IconButton(
          //             icon: const Icon(
          //               Icons.arrow_back,
          //               color: Color(0xFF229F3B),
          //               size: 30,
          //             ),
          //             onPressed: () {
          //               Navigator.pushNamed(context, "/config");
          //             },
          //             tooltip: "Config 페이지로 이동",
          //           ),
          //           const Padding(
          //             padding: EdgeInsets.only(left: 4.0),
          //             child: Text(
          //               "채팅페이지",
          //               style: TextStyle(
          //                 fontSize: 18,
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.black,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       // 오른쪽: 기존 채팅 아이콘
          //       Row(
          //         children: [
          //           IconButton(
          //             icon: const Icon(
          //               Icons.chat_bubble,
          //               color: Color(0xFF229F3B),
          //               size: 30,
          //             ),
          //             onPressed: () => _showComingSoonDialog(context),
          //             tooltip: "채팅페이지",
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ),
        body: Container(color: Colors.grey[100], child: const _ChatPage()),
      ),
    );
  }
}

// "준비중" 다이얼로그 함수
void _showComingSoonDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text("준비중"),
          content: const Text("해당 기능은 아직 준비중입니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        ),
  );
}

class _ChatPage extends StatelessWidget {
  const _ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
