import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("메인페이지"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(color: Colors.grey[100], child: _MainPage()),
    );
  }
}

class _MainPage extends StatefulWidget {
  const _MainPage({super.key});

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
