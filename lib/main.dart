import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/pages/mainPage.dart';
import 'package:slivermate_project_flutter/pages/introducePage.dart';
import 'package:slivermate_project_flutter/pages/categoryPage.dart';
import 'package:slivermate_project_flutter/pages/purchasePage.dart';
import 'package:slivermate_project_flutter/pages/callStaffPage.dart';
import 'package:slivermate_project_flutter/pages/notificationPage.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:slivermate_project_flutter/vo/categoryVo.dart';
import 'package:slivermate_project_flutter/pages/configPage.dart';
import 'package:slivermate_project_flutter/pages/chatPage.dart';
import 'package:slivermate_project_flutter/pages/userProfilePage.dart';
import 'package:slivermate_project_flutter/pages/postPage.dart';
import 'package:slivermate_project_flutter/pages/clubPage.dart';
import 'package:slivermate_project_flutter/vo/postVo.dart';
import 'package:slivermate_project_flutter/pages/chatTestPage.dart';
import 'package:slivermate_project_flutter/pages/loginPage.dart';
import 'package:slivermate_project_flutter/pages/signUpPage.dart';
import 'package:slivermate_project_flutter/pages/selectAccountPage.dart';
import 'package:slivermate_project_flutter/pages/signUpPage2.dart';
import 'package:slivermate_project_flutter/pages/newPostPage.dart';
import 'package:slivermate_project_flutter/pages/clubDetailPage.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final CategoryVo? categoryVo;
  const MyApp({super.key, this.categoryVo});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //  더미 유저 데이터 (19번 유저)
    final UserVo dummyUser = UserVo(
      uid: 19,
      userName: "user1",
      nickname: "User",
      userId: "user1",
      userPassword: "user1",
      pinPassword: "1234", //
      telNumber: "010-0055-1122",
      email: "user1@naver.com",
      thumbnail: "",
      regionId: 1, // guId → regionId로 변경
      recommendUid: null,
      registerDate: "2025-03-18T10:00:00.000+00:00",
      isDeleted: false,
      isAdmin: false,
      updDate: "2025-03-18T10:00:00.000+00:00",
      groupId: 1,
      userType: 1,
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
            // (context) => MainPage(dummyUser: dummyUser, categoryVo: categoryVo),
            (context) => ConfigPage(),
        "/purchase": (context) => PurchasePage(dummyUser: dummyUser),
        "/call": (context) => CallStaffPage(dummyUser: dummyUser),
        "/notifications": (context) => NotificationPage(dummyUser: dummyUser, isEditing: false),
        "/config": (context) => ConfigPage(),
        "/userprofile": (context) => UserProfilePage(),
        "/chat": (context) => ChatPage(),
        "/post": (context) => PostPage(dummyPost: dummyPost),
        "/category": (context) => CategoryPage(dummyUser: dummyUser),
        "/club": (context) => ClubPage(),
        "/loginPage": (context) => LoginPage(dummyUser: dummyUser),
        "/signUpPage": (context) => SignUpPage(),
        "/selectAccount": (context) {
          final args = ModalRoute.of(context)?.settings.arguments as List<UserVo>;
          return SelectAccountPage(userList: args);
        },
        "/signUpPage2": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as List<UserVo>;
          return SignUpPage2(userList: args);
        },
        "/newPostPage": (context) => NewPostPage(),

        // "/clubDetailPage": (context) => ClubDetailPage(),

        // test
        "/chatTest": (context) => ChatTestPage(),
      },
    );
  }
}
