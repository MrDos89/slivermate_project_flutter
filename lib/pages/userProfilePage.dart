import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slivermate_project_flutter/components/userInfoPage.dart';

// -----------------------------------
// 마이페이지 메인 화면 (UserProfilePage)
// -----------------------------------
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
  // List<UserVo>? userList;

  const _UserProfilePage({super.key});

  @override
  State<_UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<_UserProfilePage> {
  // late List<UserVo> _accounts;
  // late List<UserVo> userList = [];
  late PersistCookieJar cookieJar;
  bool isLoading = true;
  UserVo? currentUser; // 로그인한 유저 정보를 저장할 변수

  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");
  static final Dio dio = Dio();
  static String sessionCheckUrl =
      "http://$ec2IpAddress:$ec2Port/api/user/session";

  @override
  void initState() {
    super.initState();
    // _accounts = widget.userList;
    // _initDioAndCheckLogin(); // 실제 서버 호출 부분은 주석 처리합니다.

    // 테스트 목적으로 더미 유저 데이터를 직접 설정 (추후 삭제)
    setState(() {
      currentUser = UserVo(
        uid: 1, // 유저 회원번호
        groupId: 1, // 그룹 아이디 (예시)
        userType: 11, // 예시: 부모1 타입
        userName: "홍길동", // 이름
        nickname: "더미 사용자", // 닉네임
        userId: "dummyUser123", // 유저 아이디
        userPassword: "password", // 비밀번호 (테스트용)
        pinPassword: "0000", // PIN 비밀번호
        telNumber: "010-1234-5678", // 전화번호
        email: "dummy@example.com", // 이메일
        thumbnail: "", // 썸네일 주소 (빈 문자열이면 기본 이미지 등 처리)
        regionId: 1, // 지역번호 (예시)
        registerDate: DateTime.now(), // 가입일자
        isDeleted: false, // 탈퇴 여부
        isAdmin: false, // 관리자 여부
        updDate: DateTime.now(), // 갱신 시간
      );
      isLoading = false;
    });
  }

  // 테스트 목적으로 더미 유저 데이터를 직접 설정 (추후 삭제)

  /*
  Future<void> _initDioAndCheckLogin() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      storage: FileStorage("${appDocDir.path}/.cookies/"),
    );
    dio.interceptors.add(CookieManager(cookieJar));

    await checkLoginStatus(); // 앱 시작 시 로그인 상태 확인
  }
  */

  // Future<void> _fetchUserData() async {
  //   final fetchUserList = await UserService.fetchUserData();
  //
  //   debugPrint(fetchUserList.toString());
  //   await Future.delayed(const Duration(seconds: 1)); // 리프레시 느낌 나게 딜레이
  //
  //   if (fetchUserList.isNotEmpty) {
  //     setState(() {
  //       userList = fetchUserList; // 데이터가 정상적으로 오면 저장
  //     });
  //   } else {
  //     debugPrint("유저 정보를 가져오지 못했습니다.");
  //   }
  // }

  // 로그인 후 사용자 정보 가져오기
  Future<void> checkLoginStatus() async {
    try {
      final response = await dio.get(sessionCheckUrl);

      if (response.statusCode == 200) {
        final user = UserVo.fromJson(response.data);
        setState(() {
          currentUser = user; // 로그인된 유저 정보를 저장
          isLoading = false;
        });
        debugPrint("로그인 유지됨 - 사용자: ${user.nickname}");
      } else {
        debugPrint("로그인되지 않음.");
        setState(() => isLoading = false);
      }
    } catch (error) {
      debugPrint('로그인 상태 확인 중 오류 발생: $error');
      setState(() => isLoading = false);
    }
  }

  // 로그아웃 처리: 쿠키와 세션 초기화
  Future<void> logout() async {
    try {
      // 로그아웃 시 세션 및 쿠키 초기화
      await cookieJar.deleteAll(); // 모든 쿠키 삭제
      // dio.interceptors.clear(); // 기존 interceptor 전부 제거
      // dio.options.headers.clear(); // Authorization 등 헤더도 제거

      // 로그아웃 후 `currentUser`를 null로 설정하여 UI 갱신
      setState(() {
        currentUser = null; // 로그인된 사용자 정보 초기화
        isLoading = true; // 로딩 상태로 전환
      });

      debugPrint("로그아웃 처리 완료");

      // 로그인 페이지로 이동 및 스택 초기화
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/loginPage',
        (route) => false,
      );
    } catch (e) {
      debugPrint("로그아웃 중 오류 발생: $e");
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

  // 맵을 사용하여 버튼 텍스트에 따른 동작을 처리하는 함수
  void _handleMenuButtonTap(String text, BuildContext context) {
    Map<String, VoidCallback> actions = {
      "회원정보": () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserInfoPage(currentUser: currentUser),
          ),
        );
      },
      // 다른 버튼의 동작도 필요하다면 여기에 추가할 수 있습니다.
    };

    // 키가 있으면 해당 동작 실행, 없으면 "준비중" 다이얼로그 실행
    (actions[text] ?? () => _showComingSoonDialog(context))();
  }

  // 버튼 하나를 빌드하는 함수
  Widget _buildMenuButton(String text) {
    return InkWell(
      onTap: () {
        _handleMenuButtonTap(text, context);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      ); // 로딩 중이면 프로그래스 인디케이터 표시
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // (1) 썸네일 + 닉네임 + 로그아웃
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 왼쪽: 썸네일 + 닉네임
                Row(
                  children: [
                    // 썸네일 (프로필 이미지)
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          currentUser?.thumbnail != null &&
                                  currentUser!.thumbnail.isNotEmpty
                              ? NetworkImage(currentUser!.thumbnail)
                              : null,
                    ),
                    const SizedBox(width: 8),
                    // 닉네임
                    Text(
                      currentUser?.nickname ?? '홍길동',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // 오른쪽: 로그아웃 버튼
                TextButton(
                  onPressed: logout,
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
}
