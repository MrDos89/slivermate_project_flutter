import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  // 입력값 저장 변수
  String userName = '';
  String nickname = '';
  String userId = '';
  String userPassword = '';
  String pinPassword = '';
  String telNumber = '';
  String email = '';
  String regionId = '';
  int userType = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 이름
              TextFormField(
                decoration: const InputDecoration(labelText: '이름'),
                onSaved: (value) => userName = value ?? '',
              ),
              // 닉네임
              TextFormField(
                decoration: const InputDecoration(labelText: '닉네임'),
                onSaved: (value) => nickname = value ?? '',
              ),
              // 아이디
              TextFormField(
                decoration: const InputDecoration(labelText: '아이디'),
                onSaved: (value) => userId = value ?? '',
              ),
              // 비밀번호
              TextFormField(
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                onSaved: (value) => userPassword = value ?? '',
              ),
              // PIN 비밀번호
              TextFormField(
                decoration: const InputDecoration(labelText: 'PIN 비밀번호'),
                obscureText: true,
                keyboardType: TextInputType.number,
                onSaved: (value) => pinPassword = value ?? '',
              ),
              // 전화번호
              TextFormField(
                decoration: const InputDecoration(labelText: '전화번호'),
                keyboardType: TextInputType.phone,
                onSaved: (value) => telNumber = value ?? '',
              ),
              // 이메일
              TextFormField(
                decoration: const InputDecoration(labelText: '이메일'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => email = value ?? '',
              ),
              // 지역번호
              TextFormField(
                decoration: const InputDecoration(labelText: '지역번호'),
                keyboardType: TextInputType.number,
                onSaved: (value) => regionId = value ?? '',
              ),
              // 유저 타입 선택 (Dropdown)
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: '유저 유형'),
                value: userType,
                onChanged: (value) => setState(() => userType = value ?? 1),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('부모님1')),
                  DropdownMenuItem(value: 2, child: Text('부모님2')),
                  DropdownMenuItem(value: 3, child: Text('자식1')),
                  DropdownMenuItem(value: 4, child: Text('자식2')),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState?.save();
                  debugPrint('회원가입 정보:');
                  debugPrint('이름: $userName, 닉네임: $nickname');
                  debugPrint('아이디: $userId, 비번: $userPassword, PIN: $pinPassword');
                  debugPrint('전화: $telNumber, 이메일: $email, 지역: $regionId');
                  debugPrint('유저타입: $userType');
                },
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

