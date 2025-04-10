import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/main.dart';
import 'package:slivermate_project_flutter/pages/callStaffPage.dart';
import 'package:slivermate_project_flutter/vo/lessonVo.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:slivermate_project_flutter/pages/categoryPage.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final bool showPaymentButton; // 결제 버튼 활성화 여부
  final LessonVo? lesson;
  final UserVo? dummyUser;

  const MainLayout({
    super.key,
    required this.child,
    this.showPaymentButton = false,
    this.lesson,
    this.dummyUser,
  });

  @override
  Widget build(BuildContext context) {
    print(
      "[MainLayout build()]  dummyUser 값: ${dummyUser?.userName}, ${dummyUser?.email}",
    );

    return Scaffold(
      body: child, // 페이지 본문
      bottomNavigationBar: _buildFooter(context), // 공통 푸터 자동 포함
    );
  }

  void _showStaffCallModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, //  바깥 클릭으로 닫히지 않도록 설정
      builder: (BuildContext context) {
        return CallStaffPage(dummyUser: dummyUser!);
      },
    );
  }

  //  공통 푸터 위젯
  Widget _buildFooter(BuildContext context) {
    void _showComingSoonDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("준비중입니다"),
            content: const Text("해당 기능은 현재 준비 중입니다."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("확인"),
              ),
            ],
          );
        },
      );
    }

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: Color(0xFFFFFFFF), boxShadow: []),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFF229F3B), size: 30),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context); // 현재 스택에서 빠지고
              }
              Navigator.pushNamed(
                context,
                "/userprofile",
                arguments: dummyUser, // 유저 정보도 같이 넘김
              );
            },
            tooltip: "마이페이지",
          ),
          IconButton(
            icon: const Icon(
              Icons.chat_bubble,
              color: Color(0xFF229F3B),
              size: 30,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context); // 현재 스택에서 빠지고
              }
              Navigator.pushNamed(
                context,
                "/chat",
                arguments: dummyUser, // 유저 정보도 같이 넘김
              );
            },
            tooltip: "채팅",
          ),
          IconButton(
            icon: const Icon(
              Icons.description,
              color: Color(0xFF229F3B),
              size: 30,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context); // 현재 스택에서 빠지고
              }
              Navigator.pushNamed(
                context,
                "/post",
                arguments: dummyUser, // 유저 정보도 같이 넘김
              );
            },
            tooltip: "자유게시판",
          ),
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
              Navigator.pushNamed(
                context,
                "/category",
                arguments: dummyUser, // 유저 정보도 같이 넘김
              );
            },
            tooltip: "강의페이지",
          ),
          IconButton(
            icon: const Icon(Icons.groups, color: Color(0xFF229F3B), size: 30),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context); // 현재 스택에서 빠지고
              }
              Navigator.pushNamed(
                context,
                "/club",
                arguments: dummyUser, // 유저 정보도 같이 넘김
              );
            },
            tooltip: "모임페이지",
          ),
        ],
      ),
    );
  }
}
