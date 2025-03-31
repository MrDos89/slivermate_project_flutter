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
  final List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    String slivermateChat = dotenv.get("SLIVERMATECHAT");

    _channel = WebSocketChannel.connect(
      Uri.parse(
        "wss://$slivermateChat.execute-api.ap-northeast-2.amazonaws.com/production/",
      ),
    );

    _channel.stream.listen((message) {
      setState(() {
        _messages.add({'sender': 'server', 'message': message});
      });
    });
  }

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
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('채팅 테스트 중')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['sender'] == 'me';
                final senderName = isMe ? "파릇" : "게스트";
                final senderImage =
                    isMe
                        ? NetworkImage(
                          "https://cdn-icons-png.flaticon.com/512/147/147144.png",
                        )
                        : NetworkImage(
                          "https://cdn-icons-png.flaticon.com/512/194/194938.png",
                        );

                final messageTime = DateTime.now();
                final timeString =
                    "${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}";

                bool showDateHeader = false;
                if (index == 0) {
                  showDateHeader = true;
                } else {
                  final prevDate = DateTime.now().subtract(Duration(days: 1));
                  if (messageTime.day != prevDate.day ||
                      messageTime.month != prevDate.month ||
                      messageTime.year != prevDate.year) {
                    showDateHeader = true;
                  }
                }

                return Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${messageTime.year}년 ${messageTime.month}월 ${messageTime.day}일 (${["일", "월", "화", "수", "목", "금", "토"][messageTime.weekday % 7]})",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isMe) ...[
                            CircleAvatar(
                              backgroundImage: senderImage,
                              radius: 18,
                            ),
                            SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Column(
                              crossAxisAlignment:
                                  isMe
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (!isMe)
                                      Text(
                                        senderName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    if (isMe)
                                      Text(
                                        senderName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.fromLTRB(
                                    10,
                                    10,
                                    10,
                                    6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isMe
                                            ? Colors.yellow[700]
                                            : Colors.grey[800],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft:
                                          isMe
                                              ? Radius.circular(12)
                                              : Radius.zero,
                                      bottomRight:
                                          isMe
                                              ? Radius.zero
                                              : Radius.circular(12),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        message['message'] ?? '',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          height: 1.4,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        timeString,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: Colors.black),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 150,
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text("카메라로 촬영하기"),
                                onTap: () => Navigator.pop(context),
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text("앨범에서 선택하기"),
                                onTap: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.emoji_emotions_outlined,
                    color:
                        _controller.text.isEmpty ? Colors.grey : Colors.black,
                  ),
                  onPressed: () {},
                ),
                if (_controller.text.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.black),
                    onPressed: _sendMessage,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
