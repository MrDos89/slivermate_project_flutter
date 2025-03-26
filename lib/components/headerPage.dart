import 'package:flutter/material.dart';

class HeaderPage extends StatelessWidget implements PreferredSizeWidget {
  /// 페이지 타이틀 (예: "채팅", "게시글", "레슨", "동아리" 등)
  final String? pageTitle;

  /// 뒤로가기 버튼 표시 여부
  final bool showBackButton;

  const HeaderPage({Key? key, this.pageTitle, this.showBackButton = false})
    : super(key: key);

  // "준비중" 팝업 다이얼로그
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
        boxShadow: [], // 필요하다면 그림자 추가 가능
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 왼쪽: 뒤로가기 버튼 + 페이지 타이틀 (조건부)
          Row(
            children: [
              if (showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF229F3B)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              if (pageTitle != null)
                Text(
                  pageTitle!,
                  style: const TextStyle(
                    color: Color(0xFF229F3B),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),

          // 오른쪽: 기존 아이콘들
          Row(
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
              // 설정
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
              // IconButton(
              //   icon: const Icon(
              //     Icons.chat_bubble,
              //     color: Color(0xFF229F3B),
              //     size: 30,
              //   ),
              //   onPressed: () => _showComingSoonDialog(context),
              //   tooltip: "채팅페이지",
              // ),
              // 게시글페이지
              // IconButton(
              //   icon: const Icon(
              //     Icons.description,
              //     color: Color(0xFF229F3B),
              //     size: 30,
              //   ),
              //   onPressed: () => _showComingSoonDialog(context),
              //   tooltip: "게시글페이지",
              // ),
              // 레슨페이지 (Navigator 예시)
              // IconButton(
              //   icon: const Icon(
              //     Icons.menu_book,
              //     color: Color(0xFF229F3B),
              //     size: 30,
              //   ),
              //   onPressed: () {
              //     if (Navigator.canPop(context)) {
              //       Navigator.pop(context); // 현재 스택에서 빠지고
              //     }
              //     Navigator.pushNamed(context, "/lesson");
              //   },
              //   tooltip: "레슨페이지",
              // ),
              // 모임페이지
              // IconButton(
              //   icon: const Icon(
              //     Icons.groups,
              //     color: Color(0xFF229F3B),
              //     size: 30,
              //   ),
              //   onPressed: () => _showComingSoonDialog(context),
              //   tooltip: "모임페이지",
              // ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
