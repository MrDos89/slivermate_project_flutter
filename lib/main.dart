import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/pages/mainPage.dart';
import 'package:slivermate_project_flutter/pages/introducePage.dart';
import 'package:slivermate_project_flutter/pages/categoryPage.dart';
import 'package:slivermate_project_flutter/pages/newClubPage.dart';
import 'package:slivermate_project_flutter/pages/paymentPage.dart';
import 'package:slivermate_project_flutter/pages/purchasePage.dart';
import 'package:slivermate_project_flutter/pages/callStaffPage.dart';
import 'package:slivermate_project_flutter/pages/notificationPage.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
// import 'package:slivermate_project_flutter/vo/categoryVo.dart';
import 'package:slivermate_project_flutter/pages/configPage.dart';
import 'package:slivermate_project_flutter/pages/chatPage.dart';
import 'package:slivermate_project_flutter/pages/userProfilePage.dart';
import 'package:slivermate_project_flutter/pages/postPage.dart';
import 'package:slivermate_project_flutter/pages/clubPage.dart';
// import 'package:slivermate_project_flutter/vo/postVo.dart';
import 'package:slivermate_project_flutter/pages/chatTestPage.dart';
import 'package:slivermate_project_flutter/pages/loginPage.dart';
import 'package:slivermate_project_flutter/pages/signUpPage.dart';
import 'package:slivermate_project_flutter/pages/selectAccountPage.dart';
import 'package:slivermate_project_flutter/pages/signUpPage2.dart';
import 'package:slivermate_project_flutter/pages/newPostPage.dart';
// import 'package:slivermate_project_flutter/pages/clubDetailPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:slivermate_project_flutter/pages/paymentPage.dart';
// import 'package:slivermate_project_flutter/pages/mainPage.dart';
import 'package:provider/provider.dart';
import 'package:slivermate_project_flutter/components/userProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // final CategoryVo? categoryVo;
  // final UserVo? userVo;
  // const MyApp({super.key, this.categoryVo});
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //  더미 유저 데이터 (19번 유저)
    // final UserVo dummyUser = UserVo(
    //   uid: 19,
    //   userName: "user1",
    //   nickname: "User",
    //   userId: "user1",
    //   userPassword: "user1",
    //   pinPassword: "1234", //
    //   telNumber: "010-0055-1122",
    //   email: "user1@naver.com",
    //   thumbnail: "",
    //   regionId: 1, // guId → regionId로 변경
    //   // recommendUid: null,
    //   registerDate: DateTime.now(),
    //   isDeleted: false,
    //   isAdmin: false,
    //   updDate: DateTime.now(),
    //   groupId: 1,
    //   userType: 1,
    // );

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
                ),
          );
        }
        return null; // 다른 라우트에 대한 처리
      },
      routes: {
        "/":
            // (context) => MainPage(dummyUser: dummyUser, categoryVo: categoryVo),
            (context) => ConfigPage(),
        "/purchase": (context) => PurchasePage(),
        "/call": (context) => CallStaffPage(),
        "/notifications":
            (context) => NotificationPage(isEditing: false),
        "/config": (context) => ConfigPage(),
        "/userprofile": (context) => UserProfilePage(),
        // "/main":
        //     (context) => MainPage(dummyUser: dummyUser, categoryVo: categoryVo),
        "/main": (context) => MainPage(),
        "/chat": (context) => ChatPage(),
        // "/post": (context) => PostPage(dummyPost: dummyPost),
        "/post": (context) => PostPage(),
        "/category": (context) => CategoryPage(),
        "/club": (context) => ClubPage(),
        "/loginPage": (context) => LoginPage(),
        // "/loginPage": (context) {
        //   final args =
        //       ModalRoute.of(context)!.settings.arguments as List<UserVo>;
        //   return SelectAccountPage(userList: args);
        // },
        "/signUpPage": (context) => SignUpPage(),
        "/selectAccount": (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as List<UserVo>;
          return SelectAccountPage(userList: args);
        },
        // "/selectAccountPage": (context) {
        //   final args =
        //       ModalRoute.of(context)!.settings.arguments as List<UserVo>;
        //   return SelectAccountPage(userList: args);
        // },
        "/signUpPage2": (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as List<UserVo>;
          return SignUpPage2(userList: args);
        },
        "/newPostPage": (context) => NewPostPage(),

        // "/clubDetailPage": (context) => ClubDetailPage(),
        "/newClubPage": (context) => NewClubPage(),

        "/paymentPage": (context) => PaymentPage(),

        // test
        "/chatTest": (context) => ChatTestPage(),
      },
    );
  }
}
