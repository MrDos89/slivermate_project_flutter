import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 반드시 필요
import 'package:slivermate_project_flutter/vo/lessonVo.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:slivermate_project_flutter/components/userProvider.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final bool showPaymentButton;
  final LessonVo? lesson;

  const MainLayout({
    super.key,
    required this.child,
    this.showPaymentButton = false,
    this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    final userVo = Provider.of<UserProvider>(context).user;

    debugPrint(
      "[MainLayout build()] 로그인 유저: ${userVo?.userId}, ${userVo?.uid}",
    );

    return Scaffold(
      body: child,
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: Color(0xFFFFFFFF), boxShadow: []),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconButton(context, Icons.person, "마이페이지", "/userprofile"),
          _buildIconButton(context, Icons.chat_bubble, "채팅", "/chat"),
          _buildIconButton(context, Icons.description, "자유게시판", "/post"),
          _buildIconButton(context, Icons.menu_book, "강의페이지", "/category"),
          _buildIconButton(context, Icons.groups, "모임페이지", "/club"),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      BuildContext context, IconData icon, String tooltip, String route) {
    return IconButton(
      icon: Icon(icon, color: Color(0xFF229F3B), size: 30),
      onPressed: () {
        if (Navigator.canPop(context)) Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
      tooltip: tooltip,
    );
  }
}
