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
import 'package:slivermate_project_flutter/pages/configPage.dart';
import 'package:slivermate_project_flutter/pages/chatPage.dart';
import 'package:slivermate_project_flutter/pages/userProfilePage.dart';
import 'package:slivermate_project_flutter/pages/postPage.dart';
import 'package:slivermate_project_flutter/pages/clubPage.dart';
import 'package:slivermate_project_flutter/pages/chatTestPage.dart';
import 'package:slivermate_project_flutter/pages/loginPage.dart';
import 'package:slivermate_project_flutter/pages/signUpPage.dart';
import 'package:slivermate_project_flutter/pages/selectAccountPage.dart';
import 'package:slivermate_project_flutter/pages/signUpPage2.dart';
import 'package:slivermate_project_flutter/pages/newPostPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:slivermate_project_flutter/components/userProvider.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('ko_KR', null);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slivermate Project',
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

        if (settings.name == '/paymentPage') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (context) => PaymentPage(
                  meetingTitle: args["meetingTitle"],
                  meetingDesc: args["meetingDesc"],
                  meetingFee: args["meetingFee"],
                  meetingTime: args["meetingTime"],
                ),
          );
        }

        return null;
      },
      routes: {
        "/": (context) => MainPage(),
        "/purchase": (context) => PurchasePage(),
        "/call": (context) => CallStaffPage(),
        "/notifications": (context) => NotificationPage(isEditing: false),
        "/config": (context) => ConfigPage(),
        "/userprofile": (context) => UserProfilePage(),
        "/main": (context) => MainPage(),
        "/chat": (context) => ChatPage(),
        "/post": (context) => PostPage(),
        "/category": (context) => CategoryPage(),
        "/club": (context) => ClubPage(),
        "/loginPage": (context) => LoginPage(),
        "/signUpPage": (context) => SignUpPage(),
        "/selectAccount": (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as List<UserVo>;
          return SelectAccountPage(userList: args);
        },
        "/signUpPage2": (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as List<UserVo>;
          return SignUpPage2(userList: args);
        },
        "/newPostPage": (context) => NewPostPage(),
        "/newClubPage": (context) => NewClubPage(),

        // "/paymentPage": (context) => PaymentPage(),
        "/chatTest": (context) => ChatTestPage(),
      },
    );
  }
}
