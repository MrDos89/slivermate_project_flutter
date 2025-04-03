import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/postVo.dart';
import 'package:slivermate_project_flutter/pages/postPage.dart';
import 'package:slivermate_project_flutter/components/postContainer.dart';
import 'package:slivermate_project_flutter/pages/postDetailPage.dart';
import 'package:slivermate_project_flutter/pages/newClubPostPage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:slivermate_project_flutter/vo/commentVo.dart';

final Map<int, List<Map<String, dynamic>>> dummyClubSchedules = {
  1: [
    {
      "title": "4월 정기 등산",
      "date": "2025.04.10 (토)",
      "time": "오전 9시",
      "location": "북한산 입구",
      "description": "서울 등산 동호회 4월 정기 모임입니다.",
      "attendingUsers": <String>[],
    },
    {
      "title": "번개 산책 모임",
      "date": "2025.04.15 (수)",
      "time": "오후 7시",
      "location": "한강 반포공원",
      "description": "가볍게 산책하며 이야기 나눠요.",
    },
  ],
  2: [], // 다른 클럽은 일정 없음
};

const String currentUser = "홍길동"; // 로그인된 사용자 (임시)

void _handleAttend(Map<String, dynamic> schedule) {
  if (!schedule.containsKey("attendingUsers")) {
    schedule["attendingUsers"] = <String>[];
  }
  if (!schedule["attendingUsers"].contains(currentUser)) {
    schedule["attendingUsers"].add(currentUser);
  }
}

void _handleDecline(Map<String, dynamic> schedule) {
  schedule["attendingUsers"]?.remove(currentUser);
}


class ClubDetailPage extends StatefulWidget {
  final Map<String, dynamic> clubData;

  const ClubDetailPage({super.key, required this.clubData});

  @override
  State<ClubDetailPage> createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  List<PostVo> clubPosts = [];
  bool _isJoined = false;

  Future<void> _refreshClubPosts() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // 클럽 관련 피드 새로 고침 로직
    });
  }

  int _selectedTabIndex = 0;

  // [yj] 댓글 모달
  void _showCommentModal(BuildContext context, PostVo post) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: MediaQuery
                  .of(context)
                  .viewInsets,
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('댓글', style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),

                    Expanded(
                      child: post.comments.isEmpty
                          ? const Center(child: Text("아직 등록된 댓글이 없습니다."))
                          : ListView.builder(
                        itemCount: post.comments.length,
                        itemBuilder: (context, index) {
                          final comment = post.comments[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                comment.userThumbnail
                                    .trim()
                                    .isEmpty ? defaultUserThumbnail : comment
                                    .userThumbnail,
                              )
                              ,
                            ),
                            title: Text(comment.userNickname,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(comment.commentText),
                            trailing: Text(
                              "${comment.commentDate.hour}:${comment.commentDate
                                  .minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ),

                    // 댓글 입력 필드
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: '댓글을 입력하세요',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            if (commentController.text
                                .trim()
                                .isNotEmpty) {
                              setModalState(() {
                                post.comments.add(CommentVo(
                                  userThumbnail: "", // 현재 사용자 프로필 이미지
                                  userNickname: "현재 사용자", // 현재 사용자 닉네임
                                  commentText: commentController.text.trim(),
                                  commentDate: DateTime.now(),
                                ));
                                commentController.clear();
                              });

                              setState(() {}); // 메인 화면 업데이트
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  // final Map<String, dynamic> dummyClubData = {
  //   "name": "서울 등산 동아리",
  //   "region": "서울특별시",
  //   "category": "운동",
  //   "description": "주말마다 서울 근교 등산을 함께해요!",
  //   "leader": "홍길동",
  //   "memberCount": 12,
  //   "maxMemberCount": 20,
  //   "createdAt": "2024.05.01",
  //   "thumbnailUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTybiZUyvUiRXzKNYkxREbcGaVhB_8lrXE6uw&s",
  // };

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.green : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildIntroSection();
      case 1:
        final clubId = widget.clubData["id"];
        final clubPosts = dummyPostList.where((p) => p.clubId == clubId).toList();

        return SizedBox(
          height: 400,
          child: postContainer(
            context,
            postList: clubPosts,
            onRefresh: _refreshClubPosts,
            onLikeTap: (post) {
              setState(() {
                post.countLikes += 1;
              });
            },
            onCommentTap: _showCommentModal,
            isClubPage: true,
          ),
        );
      case 2:
        final clubId = widget.clubData["id"];
        final imagePosts = dummyPostList.where((p) =>
        p.clubId == clubId && p.postImage != null && p.postImage!.isNotEmpty
        ).toList();

        if (imagePosts.isEmpty) {
          return SizedBox(
            height: 300,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.photo_library_outlined, size: 60, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    "등록된 사진이 없습니다.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "사진이 포함된 게시물을 올려주세요.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3개씩 한 줄
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: imagePosts.length,
            itemBuilder: (context, index) {
              final post = imagePosts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailPage(Post: post),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(post.postImage!, fit: BoxFit.cover),
                ),
              );
            },
          ),
        );
      case 3:
        return _buildScheduleSection(widget.clubData["id"]);
      default:
        return const SizedBox.shrink();
    }
  }

  List<PostVo> filteredPostListForClub() {
    // clubId를 기준으로 피드를 필터링
    return dummyPostList
        .where((post) => post.clubId == widget.clubData["id"])
        .toList();
  }

  Widget _buildIntroSection() {
    final String name = widget.clubData["name"]?.toString() ?? "이름 없음";
    final String createdAt = widget.clubData["createdAt"]?.toString() ?? "-";
    final String leader = widget.clubData["leader"]?.toString() ?? "-";
    final int memberCount = widget.clubData["memberCount"] as int? ?? 0;
    final int maxCount = widget.clubData["maxMemberCount"] as int? ?? 0;
    final String description =
        widget.clubData["description"]?.toString() ?? "-";

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "개설일: $createdAt",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 4),
                  Text("모임장: $leader", style: const TextStyle(fontSize: 16)),
                  const Icon(
                    Icons.workspace_premium,
                    color: Colors.amber,
                    size: 20,
                  ),
                ],
              ),
              Text(
                "인원: $memberCount / $maxCount명",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(description, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    final String thumbnailUrl =
        widget.clubData["thumbnailUrl"]?.toString() ?? "";

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Image.network(
        thumbnailUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Text("이미지를 불러올 수 없습니다"));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainLayout(
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: const HeaderPage(pageTitle: "모임 상세", showBackButton: true),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildThumbnail(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTabButton("소개", 0),
                        _buildTabButton("피드", 1),
                        _buildTabButton("사진", 2),
                        _buildTabButton("일정", 3),
                      ],
                    ),
                  ),
                  _buildTabContent(),
                ],
              ),
            ),
            // 여기선 FAB 삭제!
          ),
        ),

        Positioned(
          bottom: 80,
          right: 16,
          child: _isJoined
              ? FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      NewClubPostPage(clubId: widget.clubData["id"]),
                ),
              );

              if (result == true) {
                await _refreshClubPosts();
              }
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.edit, color: Colors.white),
          )
              : SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isJoined = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("모임에 가입되었습니다!")),
                );
              },
              backgroundColor: Colors.green,
              shape: const CircleBorder(),
              child: const Text(
                "가입하기",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 일정 탭 위젯
Widget _buildScheduleSection(int clubId) {
  final schedules = dummyClubSchedules[clubId] ?? [];

  // 날짜별로 일정 맵핑
  final Map<DateTime, List<Map<String, dynamic>>> scheduleMap = {};
  for (var item in schedules) {
    final parts = item['date'].split('.');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2].split(' ')[0]);
    final date = DateTime.utc(year, month, day);
    scheduleMap.putIfAbsent(date, () => []).add(item);
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  return StatefulBuilder(
    builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: (day) {
                final dateKey = DateTime.utc(day.year, day.month, day.day);
                return scheduleMap[dateKey] ?? [];
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onDayLongPressed: (selectedDay, focusedDay) {
                final dateKey = DateTime.utc(
                    selectedDay.year, selectedDay.month, selectedDay.day);
                final events = scheduleMap[dateKey] ?? [];

                if (events.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setModalState) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: Text(
                              "${selectedDay.year}년 ${selectedDay
                                  .month}월 ${selectedDay.day}일 일정",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: events.map<Widget>((event) {
                                  final List<
                                      String> attendingUsers = event["attendingUsers"] ??
                                      <String>[];

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(event['title'],
                                          style: const TextStyle(fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(
                                          "${event['time']} · ${event['location']}"),
                                      const SizedBox(height: 4),
                                      Text(event['description']),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (!attendingUsers.contains(
                                                      currentUser)) {
                                                    setModalState(() {
                                                      attendingUsers.add(
                                                          currentUser);
                                                      event["attendingUsers"] =
                                                          attendingUsers;
                                                    });
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    minimumSize: const Size(
                                                        50, 30)),
                                                child: const Text("참석",
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ),
                                              const SizedBox(width: 8),
                                              OutlinedButton(
                                                onPressed: () {
                                                  setModalState(() {
                                                    attendingUsers.remove(
                                                        currentUser);
                                                    event["attendingUsers"] =
                                                        attendingUsers;
                                                  });
                                                },
                                                style: OutlinedButton.styleFrom(
                                                    minimumSize: const Size(
                                                        50, 30)),
                                                child: const Text("불참",
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.people, size: 16,
                                                  color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Text(
                                                "참석 ${attendingUsers.length}명",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("닫기"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                }
              },
              calendarFormat: CalendarFormat.month,
              onFormatChanged: (_) {},
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: const CalendarStyle(
                markersMaxCount: 0,
                selectedDecoration: BoxDecoration(),
              ),
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, day, focusedDay) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
                defaultBuilder: (context, day, focusedDay) {
                  final dateKey = DateTime.utc(day.year, day.month, day.day);
                  final hasEvents = scheduleMap[dateKey]?.isNotEmpty ?? false;

                  if (hasEvents) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedDay != null && scheduleMap[_selectedDay] != null)
              ...scheduleMap[_selectedDay]!.map((schedule) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(schedule["title"], style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("${schedule["date"]} / ${schedule["time"]}"),
                      Text("장소: ${schedule["location"]}"),
                      const SizedBox(height: 6),
                      Text(schedule["description"]),
                    ],
                  ),
                ),
              )),
            if (_selectedDay == null || scheduleMap[_selectedDay] == null)
              const Text("해당 날짜에 일정이 없습니다."),
          ],
        ),
      );
    },
  );
}