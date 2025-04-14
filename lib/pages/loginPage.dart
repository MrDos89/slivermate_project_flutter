import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:provider/provider.dart';
import 'package:slivermate_project_flutter/components/userProvider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorText;

  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");
  static final Dio dio = Dio();
  static String loginUrl = "http://$ec2IpAddress:$ec2Port/api/user/login";
  static String userGroupUrl = "http://$ec2IpAddress:$ec2Port/api/usergroup";
  static String sessionCheckUrl =
      "http://$ec2IpAddress:$ec2Port/api/user/session";

  late PersistCookieJar cookieJar;

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

    await checkLoginStatus(); // 앱 시작 시 로그인 상태 확인
  }

  Future<void> _login() async {
    debugPrint("로그인 시도 중..."); //  (준일) 로그추가
    setState(() {
      isLoading = true;
      errorText = null;
    });

    final userId = emailController.text.trim();
    final password = passwordController.text.trim();

    if (userId.isEmpty || password.isEmpty) {
      setState(() {
        isLoading = false;
        errorText = "아이디와 비밀번호를 모두 입력해주세요.";
      });
      return;
    }

    try {
      debugPrint("로그인 요청 URL: $loginUrl"); // (준일) 로그추가
      final response = await dio.post(
        loginUrl,
        data: {"user_id": userId, "password": password},
        options: Options(
          contentType: "application/json",
          validateStatus: (status) => status! < 500,
        ),
      );
      // 준일 로그 추가
      debugPrint("로그인 응답 상태 코드: ${response.statusCode}");
      debugPrint("로그인 응답 데이터: ${response.data}");

      if (response.statusCode == 200) {
        final userData = UserVo.fromJson(response.data);
        // 준일 로그 추가
        debugPrint(
          "로그인 성공 - 사용자: ${userData.userName}, 그룹 ID: ${userData.groupId}",
        );
        await loadUserGroupByGroupId(userData.groupId);

        // 로그인 성공: 세션 쿠키 자동 저장됨
        setState(() {
          isLoading = false;
        });
      } else {
        debugPrint("로그인 실패 - 잘못된 자격 정보"); //  준일 로그추가
        setState(() {
          isLoading = false;
          errorText = "아이디 또는 비밀번호가 잘못되었습니다.";
        });
      }
    } catch (error) {
      print('로그인 요청 중 오류 발생: $error');
      setState(() {
        isLoading = false;
        errorText = "서버 연결에 실패했습니다.";
      });
    }
  }

  Future<void> loadUserGroupByGroupId(int groupId) async {
    try {
      debugPrint("유저 그룹 조회 시작 - 그룹 ID: $groupId"); //  준일 로그추가
      final response = await dio.get('$userGroupUrl/$groupId');

      //  준일 로그추가
      debugPrint("유저 그룹 응답 상태: ${response.statusCode}");
      debugPrint("유저 그룹 응답 데이터: ${response.data}");

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData is List) {
          //  responseData가 List라면, UserVo 리스트로 변환
          final List<UserVo> userList =
              responseData
                  .map((e) => UserVo.fromJson(e as Map<String, dynamic>))
                  .toList();
          debugPrint("유저 그룹 파싱 완료 - ${userList.length}명"); //  준일로그추가
          Navigator.pushReplacementNamed(
            context,
            '/selectAccount',
            arguments: userList,
          );
          // Navigator.pushNamed(context, '/selectAccountPage', arguments: userList,);
        } else {
          debugPrint("서버 응답이 리스트가 아님"); //  준일 로그추가
          setState(() {
            isLoading = false;
            errorText = "서버 응답이 예상과 다릅니다. 관리자에게 문의하세요.";
          });
        }
      }
    } catch (error) {
      debugPrint('유저 그룹 호출 중 오류 발생: $error');
    }
  }

  Future<void> checkLoginStatus() async {
    try {
      final response = await dio.get(sessionCheckUrl);

      if (response.statusCode == 200) {
        final user = UserVo.fromJson(response.data); // 준일 추가

        Provider.of<UserProvider>(context, listen: false).setUser(user);

        debugPrint("로그인 유지됨 - 사용자: ${UserVo.fromJson(response.data)}");
      } else {
        debugPrint("로그인되지 않음.");
      }
    } catch (error) {
      debugPrint('로그인 상태 확인 중 오류 발생: $error');
    }
  }

  void _goToSignup() {
    Navigator.pushNamed(context, '/signUpPage');
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE5F3E8), width: 2),
        borderRadius: BorderRadius.circular(4.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );

    return MainLayout(
      child: Column(
        children: [
          const HeaderPage(pageTitle: "로그인", showBackButton: true),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(inputDecorationTheme: inputDecoration),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: '아이디를 입력해주세요.',
                            labelStyle: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.bold,
                            ),
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: '비밀번호를 입력해주세요.',
                            labelStyle: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.bold,
                            ),
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (errorText != null)
                          Text(
                            errorText!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF84C99C),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child:
                                    isLoading
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : const Text(
                                          '로그인',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _goToSignup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade300,
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text(
                                  '회원가입',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
