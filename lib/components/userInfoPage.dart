import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';

class UserInfoPage extends StatelessWidget {
  final UserVo? currentUser;
  const UserInfoPage({Key? key, required this.currentUser}) : super(key: key);

  // "준비중" 다이얼로그 함수 (필요 시 재사용)
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
    return MainLayout(
      child: Scaffold(
        // 헤더: HeaderPage 위젯 사용 (타이틀: 회원정보)
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "회원정보"),
        ),
        // 푸터 적용 (하단 네비게이션 바)
        body: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child:
                  currentUser != null
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 프로필 이미지 및 기본 정보
                          Center(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  currentUser!.thumbnail.isNotEmpty
                                      ? NetworkImage(currentUser!.thumbnail)
                                      : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "이름: ${currentUser!.userName}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "닉네임: ${currentUser!.nickname}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "아이디: ${currentUser!.userId}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "전화번호: ${currentUser!.telNumber}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "이메일: ${currentUser!.email}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          // 추가 정보 항목은 필요에 따라 아래에 추가
                        ],
                      )
                      : const Center(child: Text("회원 정보를 불러올 수 없습니다.")),
            ),
          ),
        ),
      ),
    );
  }
}
