import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatTestPage extends StatelessWidget {
  const ChatTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "채팅 테스트 페이지"),
        ),
        body: Container(color: Colors.grey[100], child: _ChatTestPage()),
      ),
    );
  }
}

class _ChatTestPage extends StatefulWidget {
  const _ChatTestPage({super.key});

  @override
  State<_ChatTestPage> createState() => _ChatTestPageState();
}

class _ChatTestPageState extends State<_ChatTestPage> {
  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel _channel;
  final List<Map<String, String>> _messages = []; // 메시지를 보낸 사람(sender) 정보 포함

  @override
  void initState() {
    super.initState();

    String slivermateChat = dotenv.get("SLIVERMATECHAT");

    // WebSocket 연결
    _channel = WebSocketChannel.connect(
      Uri.parse(
        "wss://$slivermateChat.execute-api.ap-northeast-2.amazonaws.com/production/",
      ),
    );

    // 서버에서 메시지 받기
    _channel.stream.listen((message) {
      setState(() {
        _messages.add({'sender': 'server', 'message': message});
      });
    });
  }

  // 메시지 보내기
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = json.encode({
        'action': 'sendmessage',
        'message': _controller.text,
      });
      _channel.sink.add(message);
      setState(() {
        _messages.add({'sender': 'me', 'message': _controller.text});
      });
      _controller.clear(); // 메시지 입력란 비우기
    }
  }

  @override
  void dispose() {
    _channel.sink.close(); // WebSocket 종료
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('채팅 테스트 중')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['sender'] == 'me';

                return ListTile(
                  title: Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        message['message']!,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Enter your message'),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
