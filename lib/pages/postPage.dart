import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // PreferredSize를 사용해 커스텀 앱바 구현
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          height: 70,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 왼쪽: 뒤로가기 버튼 + 페이지 타이틀
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
                    "게시글페이지",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              // 오른쪽: 기존 아이콘 (예: 레슨페이지 아이콘)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.menu_book,
                      color: Color(0xFF229F3B),
                      size: 30,
                    ),
                    onPressed: () => _showComingSoonDialog(context),
                    tooltip: "게시글페이지",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(color: Colors.grey[100], child: const _PostPage()),
    );
  }
}

// "준비중" 팝업 다이얼로그 함수
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

class _PostPage extends StatelessWidget {
  const _PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
