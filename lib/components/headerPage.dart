import 'package:flutter/material.dart';

class HeaderPage extends StatelessWidget implements PreferredSizeWidget {
  const HeaderPage({Key? key}) : super(key: key);

  // "준비중" 팝업 다이얼로그를 띄우는 함수
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        boxShadow: [], // 필요에 따라 그림자 효과 추가 가능
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 마이페이지
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Color(0xFF229F3B),
              size: 30,
            ),
            onPressed: () => _showComingSoonDialog(context),
            tooltip: "마이페이지",
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Color(0xFF229F3B),
              size: 30,
            ),
            onPressed: () => _showComingSoonDialog(context),
            tooltip: "설정",
          ),
          // 채팅페이지
          IconButton(
            icon: const Icon(
              Icons.chat_bubble,
              color: Color(0xFF229F3B),
              size: 30,
            ),
            onPressed: () => _showComingSoonDialog(context),
            tooltip: "채팅페이지",
          ),
          // 게시글페이지
          IconButton(
            icon: const Icon(
              Icons.description,
              color: Color(0xFF229F3B),
              size: 30,
            ),
            onPressed: () => _showComingSoonDialog(context),
            tooltip: "게시글페이지",
          ),
          // 레슨페이지 (Navigator 예시)
          IconButton(
            icon: const Icon(
              Icons.menu_book,
              color: Color(0xFF229F3B),
              size: 30,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context); // 현재 스택에서 빠지고
              }
              Navigator.pushNamed(context, "/lesson");
            },
            tooltip: "레슨페이지",
          ),
          // 동아리페이지
          IconButton(
            icon: const Icon(Icons.groups, color: Color(0xFF229F3B), size: 30),
            onPressed: () => _showComingSoonDialog(context),
            tooltip: "동아리페이지",
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
