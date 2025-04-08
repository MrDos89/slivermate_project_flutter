import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:slivermate_project_flutter/vo/messageVo.dart';

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
  ///  **API 요청 기능 추가 (Dio 사용)**
  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");

  static final Dio dio = Dio();
  static String sessionCheckUrl =
      "http://$ec2IpAddress:$ec2Port/api/user/session";

  bool isLoggedIn = false;
  UserVo? user;

  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel _channel;
  final List<MessageVo> _messages = [];
  Timer? _guestMessageTimer;

  @override
  void initState() {
    super.initState();
    String slivermateChat = dotenv.get("SLIVERMATECHAT");

    final channelId = '1-8-10';

    final wsUrl =
        "wss://$slivermateChat.execute-api.ap-northeast-2.amazonaws.com/production/?channel=$channelId";

    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    // _channel.sink.add(
    //   json.encode({'action': 'subscribe', 'channel': channelId}),
    // );

    // _channel = WebSocketChannel.connect(
    //   Uri.parse(
    //     "wss://$slivermateChat.execute-api.ap-northeast-2.amazonaws.com/production/",
    //   ),
    // );

    _channel.stream.listen((message) {
      try {
        var decodedMessage = json.decode(message);

        String receivedMessage = decodedMessage['message'] ?? 'No message';
        String nickname = decodedMessage['nickname'] ?? 'No nickname';
        String thumbnail = decodedMessage['thumbnail'] ?? 'No thumbnail';

        setState(() {
          _messages.add(
            MessageVo(
              sender: 'guest',
              nickname: nickname,
              thumbnail: thumbnail,
              message: receivedMessage,
              updDate: DateTime.now(),
            ),
          );
        });
      } catch (e) {
        print('Error decoding message: $e');
      }
    });

    checkLoginStatus();

    // 일정 간격으로 guest 메시지 자동 추가
    // _guestMessageTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
    //   setState(() {
    //     _messages.add({
    //       'sender': 'guest',
    //       'message': 'UI 테스트 메시지입니다.',
    //       'time': DateTime.now(),
    //     });
    //   });
    // });
  }

  Future<void> checkLoginStatus() async {
    try {
      final response = await dio.get(sessionCheckUrl);

      if (response.statusCode == 200) {
        print("로그인 유지됨 - 사용자: ${UserVo.fromJson(response.data)}");

        user = UserVo.fromJson(response.data);
      } else {
        print("로그인되지 않음.");
      }
    } catch (error) {
      print('로그인 상태 확인 중 오류 발생: $error');
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final messageText = _controller.text;
      final message = json.encode({
        'action': 'sendmessage', // 이건 그대로 두고
        'channelId': '1-8-10',
        'message': messageText,
        'nickname': user?.nickname ?? '익명',
        'thumbnail': user?.thumbnail ?? '',
        // 'upd_date': DateTime.now().toIso8601String(),
      });

      _channel.sink.add(message);

      setState(() {
        _messages.add(
          MessageVo(
            sender: 'me',
            nickname: user?.nickname ?? '나',
            thumbnail: user?.thumbnail ?? '',
            message: messageText,
            updDate: DateTime.now(),
          ),
        );
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
                final isMe = message.sender == 'me';
                final messageTime = message.updDate;
                final timeString =
                    "${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}";

                bool showDateHeader = false;
                if (index == 0) {
                  showDateHeader = true;
                } else {
                  final prevTime = _messages[index - 1].updDate;
                  showDateHeader =
                      messageTime.day != prevTime.day ||
                      messageTime.month != prevTime.month ||
                      messageTime.year != prevTime.year;
                }

                final senderName = isMe ? "파릇" : message.nickname;
                final senderImage = NetworkImage(
                  message.thumbnail,
                ); // 또는 NetworkImage(message.thumbnail) 로 변경 가능

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
                                      message.message ?? '',
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
