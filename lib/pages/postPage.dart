import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        // PreferredSize를 사용해 커스텀 앱바 구현
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(),
        ),
        body: Container(color: Colors.grey[100], child: const _PostPage()),
      ),
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
