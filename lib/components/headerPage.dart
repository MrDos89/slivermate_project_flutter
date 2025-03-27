import 'package:flutter/material.dart';

class HeaderPage extends StatelessWidget implements PreferredSizeWidget {
  /// 페이지 타이틀 (예: "채팅", "게시글", "레슨", "동아리" 등)
  final String pageTitle;

  /// 뒤로가기 버튼 표시 여부
  final bool showBackButton;

  const HeaderPage({Key? key, this.pageTitle = '', this.showBackButton = false})
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
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: const Color(0xFF044E00).withAlpha(128),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFFFFFFFF),
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/config");
                },
                tooltip: "Config 페이지로 이동",
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Text(
                  pageTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ],
          ),
          // 오른쪽: 기존 아이콘들
          Row(
            children: [
              // 알람
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Color(0xFFFFFFFF),
                  size: 30,
                ),
                onPressed: () => _showComingSoonDialog(context),
                tooltip: "알람",
              ),
              // 설정
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Color(0xFFFFFFFF),
                  size: 30,
                ),
                onPressed: () => _showComingSoonDialog(context),
                tooltip: "설정",
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
