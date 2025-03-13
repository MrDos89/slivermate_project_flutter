import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/pages/mainPage.dart';
import 'package:slivermate_project_flutter/pages/introducePage.dart';
import 'package:slivermate_project_flutter/pages/categoryPage.dart';
import 'package:slivermate_project_flutter/pages/purchasePage.dart';
import 'package:slivermate_project_flutter/pages/CallStaffPage.dart';
import 'package:slivermate_project_flutter/pages/NotificationPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slivermate Project', //@dhkim - 가제
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => MainPage(),
        "/category": (context) => CategoryPage(),
        "/introduce": (context) => IntroducePage(),
        "/purchase": (context) => PurchasePage(),
        "/call": (context) => CallStaffPage(),
        "/notifications": (context) => NotificationPage(),
      },
    );
  }
}
