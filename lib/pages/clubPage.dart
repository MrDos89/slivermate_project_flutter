import 'package:flutter/material.dart';

class ClubPage extends StatelessWidget {
  const ClubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          height: 70,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 왼쪽: 뒤로가기 버튼과 "모임 페이지" 텍스트를 함께 표시
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF229F3B),
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/config");
                    },
                    tooltip: "Config 페이지로 이동",
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "모임 페이지",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              // 오른쪽: 기존 아이콘 (예: 모임 아이콘)
              Row(
                children: [
                  // IconButton(
                  //   icon: const Icon(
                  //     Icons.groups,
                  //     color: Color(0xFF229F3B),
                  //     size: 30,
                  //   ),
                  //   onPressed: () => _showComingSoonDialog(context),
                  //   tooltip: "모임 페이지",
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(color: Colors.grey[100], child: const _ClubPage()),
    );
  }
}

// "준비중" 다이얼로그 함수 (기존 코드)
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

class _ClubPage extends StatefulWidget {
  const _ClubPage({super.key});

  @override
  State<_ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<_ClubPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
