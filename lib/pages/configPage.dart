import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("config 페이지"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(color: Colors.grey[100], child: _ConfigPage()),
    );
  }
}

class _ConfigPage extends StatefulWidget {
  const _ConfigPage({super.key});

  @override
  State<_ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<_ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          children: <Widget>[
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/userprofile");
                },
                child: Text("유저 페이지로 이동"),
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/chat");
                },
                child: Text("채팅 페이지로 이동"),
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/post");
                },
                child: Text("게시판 페이지로 이동"),
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/category");
                },
                child: Text("레슨 페이지로 이동"),
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/club");
                },
                child: Text("동아리 페이지로 이동"),
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/notifications");
                },
                child: Text("알람 페이지로 이동"),
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/chatTest");
                },
                child: Text("채팅 테스트 페이지"),
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/loginPage");
                },
                child: Text("로그인 페이지로 이동"),
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/signUpPage");
                },
                child: Text("회원가입 페이지로 이동"),
              ),
            ),
            // SizedBox(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.pushNamed(context, "/purchase");
            //     },
            //     child: Text("결제 화면으로 이동"),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
