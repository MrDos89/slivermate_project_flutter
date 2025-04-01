import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';

class LoginPage extends StatefulWidget {
  final UserVo? dummyUser;
  const LoginPage({super.key, required this.dummyUser});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorText;


  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorText = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        isLoading = false;
        errorText = "아이디와 비밀번호를 모두 입력해주세요.";
      });
      return;
    }

    final dummy = widget.dummyUser;

    if (dummy != null &&
        email == dummy.userId &&
        password == dummy.userPassword) { // 여기에 주의!
      setState(() {
        isLoading = false;
      });

      print("로그인 성공 - 사용자: ${dummy.nickname}");

      Navigator.pushNamed(
        context,
        '/selectAccount',
        arguments: [dummy],
      );
    } else {
      setState(() {
        isLoading = false;
        errorText = "아이디 또는 비밀번호가 잘못되었습니다.";
      });
    }

    // [yj] 서버랑 연동 시 사용할 코드
    // final email = emailController.text.trim();
    // final password = passwordController.text.trim();
    //
    // if (email.isEmpty || password.isEmpty) {
    //   setState(() {
    //     isLoading = false;
    //     errorText = "아이디와 비밀번호를 모두 입력해주세요.";
    //   });
    //   return;
    // }
    //
    // // TODO: 로그인 API 연동
    // print("로그인 시도: $email / $password");
    //
    // setState(() {
    //   isLoading = false;
    // });
    //
    // print("로그인 성공 - 사용자: $email");
    //
    // Navigator.pushNamed(
    //   context,
    //   '/selectAccount',
    //   arguments: [widget.dummyUser],
    // );


  // void _goToFindPassword() {
  //   Navigator.pushNamed(context, '/find-password');
  // }

  // void _showComingSoonDialog(BuildContext context) {
  // showDialog(
  //   context: context,
  //   builder:
  //       (context) => AlertDialog(
  //         title: const Text("준비중"),
  //         content: const Text("해당 기능은 아직 준비중입니다."),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("확인"),
  //           ),
  //         ],
  //       ),
  // );
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
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: inputDecoration,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: '아이디를 입력해주세요.',
                            labelStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold),
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: '비밀번호를 입력해주세요.',
                            labelStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold),
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (errorText != null)
                          Text(errorText!,
                              style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF84C99C),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : const Text('로그인', style: TextStyle(fontSize: 20,  fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _goToSignup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade300,
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text('회원가입', style: TextStyle(fontSize: 19,  fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),

                        // const SizedBox(height: 12),
                        //
                        // // 비밀번호 찾기
                        // Align(
                        //   alignment: Alignment.center,
                        //   child: TextButton(
                        //     onPressed: () => _showComingSoonDialog(context),
                        //     child: const Text(
                        //       '비밀번호를 잊으셨나요?',
                        //       style: TextStyle(fontSize: 14, color: Colors.grey),
                        //     ),
                        //   ),
                        // ),
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
