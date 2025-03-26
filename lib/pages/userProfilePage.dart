import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 기본 AppBar 대신 PreferredSize + Container 사용
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          // (1) 높이 지정
          height: 70,
          // (2) 투명 배경
          color: Colors.transparent,
          // (3) 수직 방향 여백을 주고 싶다면 아래 padding 추가 가능
          // padding: const EdgeInsets.symmetric(vertical: 10),

          // (4) 왼쪽에 텍스트, 오른쪽에 아이콘 2개
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 왼쪽 텍스트
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "마이페이지",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // 필요 시 원하는 색상 지정
                  ),
                ),
              ),
              // 오른쪽 아이콘들
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications,
                      color: Color(0xFF229F3B),
                      size: 30,
                    ),
                    onPressed: () => _showComingSoonDialog(context),
                    tooltip: "알람",
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
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(color: Colors.grey[100], child: const _UserProfilePage()),
    );
  }
}

class _UserProfilePage extends StatefulWidget {
  const _UserProfilePage({super.key});

  @override
  State<_UserProfilePage> createState() => _UserProfilePageState();
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

class _UserProfilePageState extends State<_UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
