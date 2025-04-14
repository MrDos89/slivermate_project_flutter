import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/reportVo.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:slivermate_project_flutter/vo/lessonVo.dart';
import 'package:slivermate_project_flutter/vo/clubVo.dart';
import 'package:slivermate_project_flutter/vo/postVo.dart';
import 'package:slivermate_project_flutter/vo/commentVo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slivermate_project_flutter/components/userInfoPage.dart';
import 'package:slivermate_project_flutter/components/lessonPage.dart';
import 'package:slivermate_project_flutter/components/classPage.dart';
import 'package:slivermate_project_flutter/components/myPostPage.dart';
import 'package:slivermate_project_flutter/pages/callStaffPage.dart';
import 'package:slivermate_project_flutter/components/meetingSchedulePage.dart';

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
        body: Container(
          color: Colors.grey[100],
          child: const _UserProfilePage(),
        ),
      ),
    );
  }
}

class _UserProfilePage extends StatefulWidget {
  const _UserProfilePage({super.key});

  @override
  State<_UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<_UserProfilePage> {
  late PersistCookieJar cookieJar;
  bool isLoading = true;
  UserVo? currentUser; // 로그인한 유저 정보를 저장할 변수

  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");
  static final Dio dio = Dio();
  static String sessionCheckUrl =
      "http://$ec2IpAddress:$ec2Port/api/user/session";

  // 로그아웃 API 엔드포인트
  static String logoutUrl = "http://$ec2IpAddress:$ec2Port/api/user/logout";

  @override
  void initState() {
    super.initState();
    _initDioAndCheckLogin();
  }

  Future<void> _initDioAndCheckLogin() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      storage: FileStorage("${appDocDir.path}/.cookies/"),
    );
    dio.interceptors.add(CookieManager(cookieJar));
    await checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      final response = await dio.get(sessionCheckUrl);
      if (response.statusCode == 200) {
        final user = UserVo.fromJson(response.data);
        setState(() {
          currentUser = user;
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

  // 로그아웃 (GET 방식)
  Future<void> logout() async {
    try {
      final response = await dio.get(logoutUrl);
      if (response.statusCode == 200) {
        debugPrint("로그아웃 API 호출 성공");
        await cookieJar.deleteAll();
        setState(() {
          currentUser = null;
          isLoading = true;
        });
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/loginPage',
          (route) => false,
        );
      } else {
        debugPrint("로그아웃 API 실패: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("로그아웃 중 오류: $e");
    }
  }

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

  // 각 버튼 클릭 시 동작
  void _handleMenuButtonTap(String text, BuildContext context) {
    Map<String, VoidCallback> actions = {
      "가족구성원": () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserInfoPage(currentUser: currentUser),
          ),
        );
      },
      "강의": () {
        final dummyLesson = LessonVo(
          lessonId: 1,
          userId: 1,
          lessonName: "누구나 쉽게 알려주는 일타강사 강의",
          lessonDesc: "이 강의는 테스트 강의입니다.",
          lessonCostDesc: "무료",
          lessonCategory: 1,
          lessonSubCategory: 1,
          lessonLecture: "dummyLecture.mp4",
          lessonThumbnail: "",
          lessonPrice: 0,
          registerDate: DateTime.now().toString(),
          isHidden: false,
          updDate: DateTime.now().toString(),
          userName: "홍길동",
          userThumbnail: "",
          lessonGroupId: 1,
          likeCount: 10,
          viewCount: 100,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonPage(lesson: dummyLesson),
          ),
        );
      },
      "모임": () {
        // 실제 currentUser 로 모임 페이지로
        if (currentUser == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassPage(currentUser: currentUser!),
          ),
        );
      },
      "모임 일정": () {
        // 새로 만든 "모임 일정" 페이지로 이동
        if (currentUser == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MeetingSchedulePage(currentUser: currentUser!),
          ),
        );
      },
    };

    // 나머지 (문의, 내 글보기, 등)는 아래에서 분기
    if (actions.containsKey(text)) {
      actions[text]!();
    } else {
      switch (text) {
        case "문의":
          showDialog(context: context, builder: (context) => CallStaffPage());
          break;
        case "내 글보기":
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      MyPostPage(myfeed: MyPostPage.generateDummyPosts()),
            ),
          );
          break;
        case "내 호스트":
        case "오늘의 운세":
          _showComingSoonDialog(context);
          break;
        default:
          _showComingSoonDialog(context);
          break;
      }
    }
  }

  // 메뉴 버튼 빌드
  Widget _buildMenuButton(String text) {
    return InkWell(
      onTap: () => _handleMenuButtonTap(text, context),
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
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // 썸네일 + 닉네임 + 로그아웃
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
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
                    Text(
                      currentUser?.nickname ?? '홍길동',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
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

          // 구독상태, 구독기간, 가입된 동아리
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

          // 기존 8개 버튼 중 "내 모임장" → "모임 일정" 으로 변경
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                _buildMenuButton("가족구성원"),
                _buildMenuButton("강의"),
                _buildMenuButton("모임"),
                _buildMenuButton("문의"),
                _buildMenuButton("내 글보기"),
                _buildMenuButton("내 호스트"),
                _buildMenuButton("모임 일정"),
                _buildMenuButton("오늘의 운세"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
