import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/chatDetailPage.dart';

class ChatDetailPage extends StatefulWidget {
  final String chatTitle; // 채팅방 제목

  const ChatDetailPage({super.key, required this.chatTitle});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  // 채팅 메시지 더미 데이터
  final List<Map<String, dynamic>> _messages = [
    {
      "userImage": "lib/images/뜨개질.jpg",
      "userName": "뜨개질",
      "message": "뜨개질 해보실래요?",
      "time": "오전 9:15",
    },
    {
      "userImage": "lib/images/등산.jpg",
      "userName": "등산",
      "message": "등산하자!",
      "time": "오전 9:20",
    },
  ];
  // 메시지 입력을 위한 컨트롤러
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: widget.chatTitle),
        ),
        body: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              // 채팅 메시지 목록
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 프로필 이미지
                          CircleAvatar(
                            backgroundImage: AssetImage(msg["userImage"]),
                            radius: 20,
                          ),
                          const SizedBox(width: 8),
                          // 닉네임, 메시지, 시간
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 닉네임
                              Text(
                                msg["userName"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // 메시지 (말풍선 스타일)
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(msg["message"]),
                              ),
                              const SizedBox(height: 4),
                              // 시간
                              Text(
                                msg["time"],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // 하단 메시지 입력창
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    // 텍스트 입력 필드
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: "메시지 입력",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 전송 버튼
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        // TODO: 메시지 전송 로직
                        // 예: setState(() { _messages.add(...); }); 등
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("메시지를 전송했습니다.")),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
