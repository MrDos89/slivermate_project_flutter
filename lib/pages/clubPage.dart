import 'package:flutter/material.dart';

class ClubPage extends StatelessWidget {
  const ClubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("동아리 페이지"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(color: Colors.grey[100], child: _ClubPage()),
    );
  }
}

class _ClubPage extends StatefulWidget {
  const _ClubPage({super.key});

  @override
  State<_ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<_ClubPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
