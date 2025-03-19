import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';

class MainPage extends StatelessWidget {
  final UserVo? dummyUser;
  const MainPage({super.key, required this.dummyUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("메인페이지"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(color: Colors.grey[100], child: _MainPage(dummyUser: dummyUser),),
    );
  }
}

class _MainPage extends StatefulWidget {
  final UserVo? dummyUser;
  const _MainPage({super.key, this.dummyUser});

  @override
  State<_MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
  bool isDebugMode = false; // 🔥 디버그 모드 상태

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          children: <Widget>[
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/category");

                  print("[mainPage] dummyUser 확인: ${widget.dummyUser?.userName}, ${widget.dummyUser?.email}");

                },
                child: Text("카데고리 화면으로 이동"),
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/introduce");
                },
                child: Text("인트로 화면으로 이동"),
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/purchase");
                },
                child: Text("결제 화면으로 이동"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
