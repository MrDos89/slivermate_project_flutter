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
import 'package:slivermate_project_flutter/vo/announceVo.dart';
import 'package:slivermate_project_flutter/pages/announcementListPage.dart';
import 'package:slivermate_project_flutter/vo/clubVo.dart';
import 'package:slivermate_project_flutter/pages/addMeetingPage.dart';

final Map<int, List<AnnounceVo>> dummyClubSchedules = {
  1: [
    AnnounceVo(
      title: "4월 정기 등산",
      date: "2025.04.10 (토)",
      time: "오전 9시",
      location: "북한산 입구",
      description: "서울 등산 동호회 4월 정기 모임입니다.",
      meetingPrice: "5,000원",
      attendingCount: 12,
      type: 2,
    ),
    AnnounceVo(
      title: "번개 산책 모임",
      date: "2025.04.15 (수)",
      time: "오후 7시",
      location: "한강 반포공원",
      description: "가볍게 산책하며 이야기 나눠요.",
      meetingPrice: "무료",
      attendingCount: 5,
      type: 2,
    ),
    AnnounceVo(
      title: "다음 달 등산 일정 사전 안내",
      date: "2025.04.20 (일)",
      time: "오전 10시",
      location: "온라인",
      description: "다음 달 정기 모임 일정을 미리 안내드립니다.",
      meetingPrice: "",
      attendingCount: 0,
      type: 1,
    ),
    AnnounceVo(
      title: "5월 모임 일정 공지",
      date: "2025.05.01 (수)",
      time: "오후 3시",
      location: "온라인",
      description: "5월 모임 일정을 공지드립니다. 참여 여부는 추후 안내 예정입니다.",
      meetingPrice: "",
      attendingCount: 0,
      type: 1,
    ),

    AnnounceVo(
      title: "신규 멤버 모집 안내",
      date: "2025.05.05 (일)",
      time: "오전 11시",
      location: "온라인",
      description: "서울 등산 동호회 신규 멤버를 모집합니다. 자세한 사항은 공지 내용을 확인하세요.",
      meetingPrice: "",
      attendingCount: 0,
      type: 1,
    ),

    AnnounceVo(
      title: "회비 납부 안내",
      date: "2025.05.10 (금)",
      time: "오전 9시",
      location: "온라인",
      description: "이번 달 회비 납부 안내입니다. 계좌정보 및 납부기한은 공지를 확인해주세요.",
      meetingPrice: "",
      attendingCount: 0,
      type: 1,
    ),

    AnnounceVo(
      title: "안전 수칙 안내",
      date: "2025.05.12 (일)",
      time: "오후 5시",
      location: "온라인",
      description: "등산 시 유의사항 및 안전 수칙을 안내드립니다. 반드시 숙지해주세요.",
      meetingPrice: "",
      attendingCount: 0,
      type: 1,
    ),

    AnnounceVo(
      title: "장비 대여 관련 공지",
      date: "2025.05.15 (수)",
      time: "오후 2시",
      location: "온라인",
      description: "등산 장비 대여 신청 방법 및 주의사항을 공지합니다.",
      meetingPrice: "",
      attendingCount: 0,
      type: 1,
    ),

  ],
};

const String currentUser = "홍길동"; // 로그인된 사용자 (임시)

// void _handleAttend(Map<String, dynamic> schedule) {
//   if (!schedule.containsKey("attendingUsers")) {
//     schedule["attendingUsers"] = <String>[];
//   }
//   if (!schedule["attendingUsers"].contains(currentUser)) {
//     schedule["attendingUsers"].add(currentUser);
//   }
// }
//
// void _handleDecline(Map<String, dynamic> schedule) {
//   schedule["attendingUsers"]?.remove(currentUser);
// }
const int currentUserId = 101;

class ClubDetailPage extends StatefulWidget {
  final ClubVo clubVo;
  const ClubDetailPage({super.key, required this.clubVo});

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
        final clubId = widget.clubVo.clubId;
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
        final clubId = widget.clubVo.clubId;
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
        return _buildScheduleSection(
          clubId: widget.clubVo.clubId,
          clubLeaderId: widget.clubVo.clubUserId,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  List<PostVo> filteredPostListForClub() {
    // clubId를 기준으로 피드를 필터링
    return dummyPostList
        .where((post) => post.clubId == widget.clubVo.clubId)
        .toList();
  }

  Widget _buildIntroSection() {
    final String name = widget.clubVo.clubName.toString();
    final DateTime createdAt = widget.clubVo.clubRegisterDate;
    final int clubUserId = widget.clubVo.clubUserId as int? ?? 0;
    final int memberCount = widget.clubVo.clubMemberNumber as int? ?? 0;
    final int maxCount = widget.clubVo.clubMemberMax as int? ?? 0;
    final String description = widget.clubVo.clubDesc.toString();

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
                  Text("모임장: $clubUserId", style: const TextStyle(fontSize: 16)),
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
        widget.clubVo.clubThumbnail.toString();

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
                      NewClubPostPage(clubId: widget.clubVo.clubId),
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
Widget _buildScheduleSection({
  required int clubId,
  required int clubLeaderId,
}) {
  final schedules = dummyClubSchedules[clubId] ?? [];
  final List<AnnounceVo> announcements =
  schedules.where((s) => s.isAnnounce).toList();

  announcements.sort((a, b) {
    DateTime dateA = DateTime.parse(a.date.split(' ').first.replaceAll('.', '-'));
    DateTime dateB = DateTime.parse(b.date.split(' ').first.replaceAll('.', '-'));
    return dateB.compareTo(dateA); // 최신 먼저
  });

  final latestNotice = announcements.isNotEmpty ? announcements.first : null;

  // 날짜별로 일정 맵핑
  final Map<DateTime, List<AnnounceVo>> scheduleMap = {};
  for (var item in schedules) {

    if (!item.isMeeting) continue; // [yj] 달력에 공지는 안 뜨게 설정

    final parts = item.date.split('.');
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
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            if (latestNotice != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AnnouncementListPage(announcements: announcements),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "📢 ${latestNotice.title}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),

            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: (day) {
                final dateKey = DateTime.utc(day.year, day.month, day.day);
                return scheduleMap[dateKey]?.where((e) => e.isMeeting).toList() ?? [];
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
                final events = scheduleMap[dateKey]?.where((e) => e.isMeeting).toList() ?? [];

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
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일 일정",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                            content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                    ),
                                    ...events.map<Widget>((event) {
                                      // int attendingCount = event.attendingCount;

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.title,
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),

                                          Text("${event.time} · ${event.location}"),
                                          const SizedBox(height: 4),

                                          Text("회비: ${event.meetingPrice}"),
                                          const SizedBox(height: 4),

                                          Text(event.description),
                                          const SizedBox(height: 10),

                                          // 참석 인원 표시
                                          Row(
                                            children: [
                                              const Icon(Icons.people, size: 16, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Text(
                                                "참석 ${event.attendingCount}명",
                                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),

                                          // 버튼 나란히
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  setModalState(() {
                                                    final updated = AnnounceVo(
                                                      title: event.title,
                                                      date: event.date,
                                                      time: event.time,
                                                      location: event.location,
                                                      description: event.description,
                                                      meetingPrice: event.meetingPrice,
                                                      attendingCount: event.attendingCount + 1,
                                                      type: event.type,
                                                    );

                                                    final index = schedules.indexOf(event);
                                                    if (index != -1) {
                                                      schedules[index] = updated;
                                                      final dateKey = DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day);
                                                      scheduleMap[dateKey] = schedules.where((e) => e.date == event.date).toList();
                                                    }
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) => AlertDialog(
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                        title: const Text("참석 확인"),
                                                        content: Text("회비는 '${event.meetingPrice}' 입니다.\n결제 페이지는 준비 중입니다."),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context),
                                                            child: const Text("확인"),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });

                                                  // 외부 상태도 갱신
                                                  (context as Element).markNeedsBuild();
                                                },
                                                style: ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
                                                child: const Text("참석", style: TextStyle(fontSize: 12)),
                                              ),
                                              const SizedBox(width: 30),
                                              OutlinedButton(
                                                onPressed: () {
                                                  setModalState(() {
                                                    final updated = AnnounceVo(
                                                      title: event.title,
                                                      date: event.date,
                                                      time: event.time,
                                                      location: event.location,
                                                      description: event.description,
                                                      meetingPrice: event.meetingPrice,
                                                      attendingCount: (event.attendingCount > 0) ? event.attendingCount - 1 : 0,
                                                      type: event.type,
                                                    );

                                                    final index = schedules.indexOf(event);
                                                    if (index != -1) {
                                                      schedules[index] = updated;

                                                      final dateKey = DateTime.utc(
                                                        selectedDay.year,
                                                        selectedDay.month,
                                                        selectedDay.day,
                                                      );
                                                      scheduleMap[dateKey] = schedules
                                                          .where((e) => e.date == event.date)
                                                          .toList();
                                                    }
                                                  });
                                                },
                                                style: OutlinedButton.styleFrom(minimumSize: const Size(100, 40)),
                                                child: const Text("불참", style: TextStyle(fontSize: 12)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
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
                    width: 40, // 원하는 값으로 줄이기 (기본 약 36~40 정도)
                    height: 40,
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
                      width: 45, // 원하는 값으로 줄이기 (기본 약 36~40 정도)
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
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
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 12),
            if (_selectedDay != null && scheduleMap[_selectedDay] != null)
              ...scheduleMap[_selectedDay]!.map((schedule) =>
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(schedule.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text("${schedule.date} / ${schedule.time}"),
                            Text("장소: ${schedule.location}"),
                            const SizedBox(height: 6),
                            Text(schedule.description),
                            Text("회비: ${schedule.meetingPrice}"),
                          ],
                        ),
                      ),
                    ),
                  ),
              ),
            if (_selectedDay == null)
              Column(
                children: const [
                  Text("날짜를 선택해 주세요"),
                ],
              )
            else if (scheduleMap[_selectedDay] == null)
              Column(
                children: [
                  const Text("해당 날짜에 일정이 없습니다."),
                  if (clubLeaderId == currentUserId)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMeetingPage(selectedDate: _selectedDay!),
                          ),
                        );
                      },
                      child: const Text('일정 추가하기'),
                    ),
                ],
              )
          ],
        ),
      );
    },
  );
}