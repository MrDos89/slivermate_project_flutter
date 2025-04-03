import 'dart:async';
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
        body: Container(
          color: const Color(0xFFE8F5E9),
          child: const _ChatTestPage(),
        ),
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
  final List<Map<String, dynamic>> _messages = [];
  Timer? _guestMessageTimer;

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
      try {
        // 서버에서 받은 메시지를 JSON으로 변환
        var decodedMessage = json.decode(message);

        // 서버에서 받은 메시지를 제대로 처리할 수 있도록 수정
        String receivedMessage = decodedMessage['message'] ?? 'No message';

        // UI에 메시지 추가
        setState(() {
          _messages.add({
            'sender': 'guest',
            'message': receivedMessage, // 메시지 내용만 추가
            'time': DateTime.now(),
          });
        });
      } catch (e) {
        print('Error decoding message: $e');
      }
    });

    // 일정 간격으로 guest 메시지 자동 추가
    _guestMessageTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      setState(() {
        _messages.add({
          'sender': 'guest',
          'message': 'UI 테스트 메시지입니다.',
          'time': DateTime.now(),
        });
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
        _messages.add({
          'sender': 'me',
          'message': _controller.text,
          'time': DateTime.now(),
        });
      });
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _guestMessageTimer?.cancel(); // 타이머 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('채팅 테스트 중')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['sender'] == 'me';
                final DateTime messageTime = message['time'];
                final timeString =
                    "${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}";

                bool showDateHeader = false;
                if (index == 0) {
                  showDateHeader = true;
                } else {
                  final prevTime = _messages[index - 1]['time'] as DateTime;
                  showDateHeader =
                      messageTime.day != prevTime.day ||
                      messageTime.month != prevTime.month ||
                      messageTime.year != prevTime.year;
                }

                final senderName = isMe ? "파릇" : "게스트";
                final senderImage =
                    isMe
                        ? const AssetImage('lib/images/뜨개질.jpg')
                        : const AssetImage('lib/images/rion.jpg');

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
                              style: const TextStyle(
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
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment:
                            isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          if (!isMe) ...[
                            CircleAvatar(
                              backgroundImage: senderImage,
                              radius: 16,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Column(
                            crossAxisAlignment:
                                isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              if (!isMe)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    senderName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (isMe)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: Text(
                                        timeString,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                      12,
                                      10,
                                      12,
                                      10,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isMe
                                              ? Colors.yellow[700]
                                              : Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(12),
                                        topRight: const Radius.circular(12),
                                        bottomLeft: Radius.circular(
                                          isMe ? 12 : 0,
                                        ),
                                        bottomRight: Radius.circular(
                                          isMe ? 0 : 12,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      message['message'] ?? '',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  if (!isMe)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: Text(
                                        timeString,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black),
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
                                leading: const Icon(Icons.camera_alt),
                                title: const Text("카메라로 촬영하기"),
                                onTap: () => Navigator.pop(context),
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text("앨범에서 선택하기"),
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
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                if (_controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
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
