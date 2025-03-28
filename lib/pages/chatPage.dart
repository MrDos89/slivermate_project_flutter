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
      "title": "뜨개질",
      "subTitle": "뜨개질 초보여도 환영합니다.",
      "dateTime": "9:55",
      "isRead": false,
      "imageUrl": "lib/images/뜨개질.jpg",
    },
    {
      "title": "그림",
      "subTitle": "그림을 못그리셔도 환영합니다.",
      "dateTime": "9:45",
      "isRead": true,
      "imageUrl": "lib/images/그림.jpg",
    },
    {
      "title": "독서",
      "subTitle": "책 읽읍시다.",
      "dateTime": "9:00",
      "isRead": false,
      "imageUrl": "lib/images/독서.jpg",
    },
    {
      "title": "영화감상",
      "subTitle": "영화감상중",
      "dateTime": "8:20",
      "isRead": true,
      "imageUrl": "lib/images/영화감상.jpg",
    },
    {
      "title": "퍼즐",
      "subTitle": "퍼즐을 맞쳐보세요",
      "dateTime": "7:30",
      "isRead": false,
      "imageUrl": "lib/images/퍼즐맞추기.jpg",
    },
    {
      "title": "요리",
      "subTitle": "Pull Request #123",
      "dateTime": "6:10",
      "isRead": true,
      "imageUrl": "lib/images/요리.jpg",
    },
    {
      "title": "통기타",
      "subTitle": "기타 고수가 되어보세요",
      "dateTime": "어제",
      "isRead": false,
      "imageUrl": "lib/images/통기타.jpg",
    },
    {
      "title": "당구",
      "subTitle": "4구 ,3구 가능",
      "dateTime": "어제",
      "isRead": true,
      "imageUrl": "lib/images/당구.jpg",
    },
    {
      "title": "바둑",
      "subTitle": "누구나 이세돌이 될 수 있어요",
      "dateTime": "그제",
      "isRead": false,
      "imageUrl": "lib/images/바둑.jpg",
    },
    {
      "title": "등산",
      "subTitle": "정상을 향하여",
      "dateTime": "어제",
      "isRead": true,
      "imageUrl": "lib/images/rion.jpg",
    },

    {
      "title": "자전거",
      "subTitle": "한강나들이 갑시다..",
      "dateTime": "9:55",
      "isRead": false,
      "imageUrl": "lib/images/rion.jpg",
    },

    {
      "title": "캠핑",
      "subTitle": "불멍하러 갑시다.",
      "dateTime": "9:55",
      "isRead": false,
      "imageUrl": "lib/images/rion.jpg",
    },

    {
      "title": "낚시",
      "subTitle": "대어 낚으러 오실분",
      "dateTime": "9:55",
      "isRead": false,
      "imageUrl": "lib/images/rion.jpg",
    },

    {
      "title": "러닝/마라톤",
      "subTitle": "누구나 이봉주가 될 수 있다.",
      "dateTime": "9:55",
      "isRead": false,
      "imageUrl": "lib/images/rion.jpg",
    },

    {
      "title": "수영",
      "subTitle": "오늘도 물속에서 힐링합시다.",
      "dateTime": "9:55",
      "isRead": false,
      "imageUrl": "lib/images/rion.jpg",
    },

    {
      "title": "골프",
      "subTitle": "홀인원 가봅시다.",
      "dateTime": "9:55",
      "isRead": false,
      "imageUrl": "lib/images/rion.jpg",
    },

    {
      "title": "테니스",
      "subTitle": "어느 누구든지 환영합니다.",
      "dateTime": "9:55",
      "isRead": false,
      "imageUrl": "lib/images/rion.jpg",
    },

    {
      "title": "족구",
      "subTitle": "내가 족구왕이다.",
      "dateTime": "9:55",
      "isRead": false,
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
