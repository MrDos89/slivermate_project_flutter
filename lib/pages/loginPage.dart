import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';

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
        errorText = "이메일과 비밀번호를 모두 입력해주세요.";
      });
      return;
    }

    // TODO: 로그인 API 연동
    print("로그인 시도: $email / $password");

    setState(() {
      isLoading = false;
    });

    Navigator.pushNamed(context, '/config');
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF229F3B), width: 2),
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
                          decoration: const InputDecoration(
                            labelText: '이메일',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: '비밀번호',
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (errorText != null)
                          Text(errorText!,
                              style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF84C99C), // 💚 연녹색
                              padding:
                              const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : const Text('로그인',
                                style: TextStyle(fontSize: 16)),
                          ),
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