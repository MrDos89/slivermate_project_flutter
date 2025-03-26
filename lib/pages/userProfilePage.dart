import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("user profile 페이지"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(color: Colors.grey[100], child: _UserProfilePage()),
    );
  }
}

class _UserProfilePage extends StatefulWidget {
  const _UserProfilePage({super.key});

  @override
  State<_UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<_UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
