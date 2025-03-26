import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("config 페이지"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(color: Colors.grey[100], child: _PostPage()),
    );
  }
}

class _PostPage extends StatelessWidget {
  const _PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
