import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          height: 70,
          color: Colors.transparent,
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
                    color: Colors.black,
                  ),
                ),
              ),
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

class _UserProfilePageState extends State<_UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    final placeholder = const Placeholder();

    return SingleChildScrollView(
      child: Column(
        children: [
          // (1) 썸네일 + 닉네임 + 로그아웃
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              // 양 끝 정렬 (썸네일+닉네임, 로그아웃)
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 왼쪽: 썸네일 + 닉네임
                Row(
                  children: [
                    // 썸네일 (프로필 이미지) - 실제 url 대신 Placeholder
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey,
                      // backgroundImage: NetworkImage('프로필 URL'),
                    ),
                    const SizedBox(width: 8),
                    // 닉네임
                    const Text(
                      "홍길동",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // 오른쪽: 로그아웃 버튼
                TextButton(
                  onPressed: () => _showComingSoonDialog(context),
                  child: const Text(
                    "로그아웃",
                    style: TextStyle(
                      color: Color(0xFF229F3B),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // (2) 구독상태, 구독기간, 가입된 동아리 - 박스 형태 (3칸)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  // 살짝 그림자
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 구독상태
                  Expanded(
                    child: Column(
                      children: const [
                        Text(
                          "구독상태",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text("O/X"),
                      ],
                    ),
                  ),
                  // 세로 구분선
                  Container(width: 1, height: 40, color: Colors.grey[300]),
                  // 구독기간
                  Expanded(
                    child: Column(
                      children: const [
                        Text(
                          "구독기간",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "2023.08.01\n~ 2023.09.01",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  // 세로 구분선
                  Container(width: 1, height: 40, color: Colors.grey[300]),
                  // 가입된 동아리
                  Expanded(
                    child: Column(
                      children: const [
                        Text(
                          "가입된 동아리",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text("4개"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // (3) 8개 버튼 (회원정보, 강의, 모임, 문의, 내 글보기, 내 호스트, 내 모임장, 오늘의 운세)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              // GridView의 스크롤 비활성화 -> 부모 SingleChildScrollView와 충돌 방지
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                _buildMenuButton("회원정보"),
                _buildMenuButton("강의"),
                _buildMenuButton("모임"),
                _buildMenuButton("문의"),
                _buildMenuButton("내 글보기"),
                _buildMenuButton("내 호스트"),
                _buildMenuButton("내 모임장"),
                _buildMenuButton("오늘의 운세"),
              ],
            ),
          ),

          const SizedBox(height: 24),

          placeholder,

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 버튼 하나를 빌드하는 함수
  Widget _buildMenuButton(String text) {
    return InkWell(
      onTap: () => _showComingSoonDialog(context),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            // 살짝 그림자
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
