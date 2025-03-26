import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("chat 페이지"),
        backgroundColor: Color(0xFF044E00).withAlpha(50),
      ),
      body: Container(color: Colors.grey[100], child: _ChatPage()),
    );
  }
}

class _ChatPage extends StatefulWidget {
  const _ChatPage({super.key});

  @override
  State<_ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<_ChatPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
