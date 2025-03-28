import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "채팅 페이지"),
        ),
        body: Container(color: Colors.grey[100], child: const _ChatPage()),
      ),
    );
  }
}

// "준비중" 다이얼로그 함수
void _showComingSoonDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text("준비중"),
          content: const Text("해당 기능은 아직 준비중입니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        ),
  );
}

class _ChatPage extends StatefulWidget {
  const _ChatPage({super.key});

  @override
  State<_ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<_ChatPage> {
  // 채팅 아이템 데이터 (스크롤 충분히 발생하도록 늘림)
  final List<Map<String, dynamic>> _chatItems = [
    {
      "title": "그냥한번해본게임 11",
      "subTitle": "임의 안내",
      "dateTime": "9:55",
      "isRead": false,
      "imageUrl": "lib/images/rion.jpg",
    },
    {
      "title": "준일",
      "subTitle": "리스트뷰 관련 (테스트, api )",
      "dateTime": "9:45",
      "isRead": true,
      "imageUrl": "lib/images/rion.jpg",
    },
    {
      "title": "쿠팡 빌딩",
      "subTitle": "예시",
      "dateTime": "9:00",
      "isRead": false,
      "imageUrl": "lib/images/rion.jpg",
    },
    {
      "title": "배달의민족",
      "subTitle": "음식 배달 관련 안내",
      "dateTime": "8:20",
      "isRead": true,
      "imageUrl": "lib/images/rion.jpg",
    },
    {
      "title": "카카오페이",
      "subTitle": "결제 알림",
      "dateTime": "7:30",
      "isRead": false,
      "imageUrl": "lib/images/rion.jpg",
    },
    {
      "title": "GitHub 알림",
      "subTitle": "Pull Request #123",
      "dateTime": "6:10",
      "isRead": true,
      "imageUrl": "lib/images/rion.jpg",
    },
    {
      "title": "Flutter Dev",
      "subTitle": "Flutter 3.7 Release",
      "dateTime": "어제",
      "isRead": false,
      "imageUrl": "lib/images/rion.jpg",
    },
    {
      "title": "Dart Updates",
      "subTitle": "Dart 2.19 Release",
      "dateTime": "어제",
      "isRead": true,
      "imageUrl": "lib/images/rion.jpg",
    },
    {
      "title": "AWS Notifications",
      "subTitle": "EC2 서버 상태",
      "dateTime": "그제",
      "isRead": false,
      "imageUrl": "lib/images/rion.jpg",
    },
    {
      "title": "Google News",
      "subTitle": "AI 관련 기사",
      "dateTime": "그제",
      "isRead": true,
      "imageUrl": "lib/images/rion.jpg",
    },
  ];

  // 현재 선택된 리스트 인덱스
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Center(
      // 원하는 너비값을 지정합니다 (가로폭 제한).
      child: SizedBox(
        width: 380,
        child: ListView.separated(
          itemCount: _chatItems.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = _chatItems[index];

            return InkWell(
              // InkWell 전체를 클릭했을 때
              onTap: () {
                // 팝업 띄우기
                _showComingSoonDialog(context);

                // 배경색 토글
                setState(() {
                  _selectedIndex = (_selectedIndex == index) ? -1 : index;
                });
              },
              child: Container(
                // 리스트 전체 영역 배경색을 바꿔도 되고,
                // 가운데 부분만 바꾸고 싶다면 Expanded 쪽에 Container를 둘 수도 있음
                color:
                    _selectedIndex == index
                        ? Colors.blue[50]
                        : Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 왼쪽: 이미지 (클릭 시 별도 처리)
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item["title"]}의 이미지를 클릭했습니다.'),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage(item["imageUrl"]),
                        radius: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 가운데: 제목 / 서브 타이틀
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["title"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item["subTitle"],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 오른쪽: 날짜/시간, 읽음/안읽음 + 빨간 동그라미
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item["dateTime"],
                              style: const TextStyle(fontSize: 14),
                            ),
                            // 읽지 않은 메시지라면 빨간색 동그라미 표시
                            if (!item["isRead"]) ...[
                              const SizedBox(width: 4),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item["isRead"] ? "읽음" : "안읽음",
                          style: TextStyle(
                            fontSize: 12,
                            color: item["isRead"] ? Colors.grey : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
