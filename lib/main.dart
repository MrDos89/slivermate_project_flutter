import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/pages/mainPage.dart';
import 'package:slivermate_project_flutter/pages/introducePage.dart';
import 'package:slivermate_project_flutter/pages/categoryPage.dart';
import 'package:slivermate_project_flutter/pages/purchasePage.dart';
import 'package:slivermate_project_flutter/pages/CallStaffPage.dart';
import 'package:slivermate_project_flutter/pages/NotificationPage.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:slivermate_project_flutter/vo/categoryVo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final CategoryVo? categoryVo;
  const MyApp({super.key, this.categoryVo});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 🔥 더미 유저 데이터 (19번 유저)
    final UserVo dummyUser = UserVo(
      uid: 19, // ✅ 필드명 지정
      userName: "user1",
      nickname: "User",
      userId: "user1",
      userPassword: "user1",
      telNumber: "010-0055-1122",
      email: "user1@naver.com",
      thumbnail: "",
      guId: 1,
      recommendUid: null,
      registerDate: "2025-03-18T10:00:00.000+00:00",
      isDeleted: false,
      isAdmin: false,
      updDate: "2025-03-18T10:00:00.000+00:00",
    );

    return MaterialApp(
      title: 'Slivermate Project', //@dhkim - 가제
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        if (settings.name == '/introduce') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => IntroducePage(
                  lessonCategory: args["lessonCategory"],
                  lessonSubCategory: args["lessonSubCategory"],
                  dummyUser: args["dummyUser"],
                ),
          );
        }
        return null; // 다른 라우트에 대한 처리
      },
      routes: {
        "/":
            (context) => MainPage(dummyUser: dummyUser, categoryVo: categoryVo),
        "/category": (context) => CategoryPage(dummyUser: dummyUser),
        "/purchase": (context) => PurchasePage(dummyUser: dummyUser),
        "/call": (context) => CallStaffPage(dummyUser: dummyUser),
        "/notifications": (context) => NotificationPage(dummyUser: dummyUser),
      },
    );
  }
}
