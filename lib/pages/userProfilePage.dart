import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "마이 페이지"),
        ),
        body: Container(color: Colors.grey[100], child: _UserProfilePage()),
      ),
    );
  }
}

class _UserProfilePage extends StatefulWidget {
  List<UserVo>? userList;

  _UserProfilePage({super.key});

  @override
  State<_UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<_UserProfilePage> {
  // late List<UserVo> _accounts;
  late List<UserVo> userList = [];
  late PersistCookieJar cookieJar;
  bool isLoading = true;

  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");
  static final Dio dio = Dio();
  static String sessionCheckUrl =
      "http://$ec2IpAddress:$ec2Port/api/user/session";

  @override
  void initState() {
    super.initState();
    // _accounts = widget.userList;

    _initDioAndCheckLogin();
    _fetchUserData();
  }

  Future<void> _initDioAndCheckLogin() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      storage: FileStorage("${appDocDir.path}/.cookies/"),
    );
    dio.interceptors.add(CookieManager(cookieJar));

    await checkLoginStatus(); // 앱 시작 시 로그인 상태 확인
  }

  Future<void> _fetchUserData() async {
    final fetchUserList = await UserService.fetchUserData();

    debugPrint(fetchUserList.toString());
    await Future.delayed(const Duration(seconds: 1)); // 리프레시 느낌 나게 딜레이

    if (fetchUserList.isNotEmpty) {
      setState(() {
        userList = fetchUserList; // 데이터가 정상적으로 오면 저장
      });
    } else {
      debugPrint("유저 정보를 가져오지 못했습니다.");
    }
  }

  Future<void> checkLoginStatus() async {
    try {
      final response = await dio.get(sessionCheckUrl);

      if (response.statusCode == 200) {
        print("로그인 유지됨 - 사용자: ${UserVo.fromJson(response.data)}");
      } else {
        print("로그인되지 않음.");
      }
    } catch (error) {
      print('로그인 상태 확인 중 오류 발생: $error');
    }
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
