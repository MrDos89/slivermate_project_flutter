import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/postVo.dart';
import 'package:slivermate_project_flutter/pages/postPage.dart';
import 'package:slivermate_project_flutter/components/postContainer.dart';
import 'package:slivermate_project_flutter/pages/postDetailPage.dart';
import 'package:slivermate_project_flutter/pages/newPostPage.dart';

// final List<PostVo> dummyPostList = [
//   PostVo(
//     userNickname: "라이언",
//     postNote: "이번 주 등산 어때요?",
//     postImage: "https://allways.kg-mobility.com/wp-content/uploads/2020/04/0429_%EB%93%B1%EC%82%B0_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",
//     countLikes: 3,
//     countComment: 2,
//     registerDate: DateTime.now().subtract(Duration(hours: 5)),
//     comments: [],
//     userThumbnail: "https://i.namu.wiki/i/vDDaVK4wm1-vPZgAOI65rbhLhr1vPCzBgoRKSS7mEFx4IH2vtHvvMN41Umw-taptksIW_WqnjwOdcGbAMpAmrQ.webp",
//     regionId: 1,
//     categoryNames: 2,
//     subCategory: 1,
//   ),
//   PostVo(
//     userNickname: "라이언",
//     postNote: "이번 주 등산 어때요?",
//     postImage: "https://allways.kg-mobility.com/wp-content/uploads/2020/04/0429_%EB%93%B1%EC%82%B0_%EC%8D%B8%EB%84%A4%EC%9D%BC.jpg",
//     countLikes: 3,
//     countComment: 2,
//     registerDate: DateTime.now().subtract(Duration(hours: 5)),
//     comments: [],
//     userThumbnail: "https://i.namu.wiki/i/vDDaVK4wm1-vPZgAOI65rbhLhr1vPCzBgoRKSS7mEFx4IH2vtHvvMN41Umw-taptksIW_WqnjwOdcGbAMpAmrQ.webp",
//     regionId: 1,
//     categoryNames: 2,
//     subCategory: 1,
//   ),
// ];

final Map<int, List<Map<String, dynamic>>> dummyClubSchedules = {
  1: [
    {
      "title": "4월 정기 등산",
      "date": "2025.04.10 (토)",
      "time": "오전 9시",
      "location": "북한산 입구",
      "description": "서울 등산 동호회 4월 정기 모임입니다.",
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
                    MaterialPageRoute(builder: (_) => PostDetailPage(Post: post)),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.postImage!,
                    fit: BoxFit.cover,
                  ),
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
    return dummyPostList.where((post) => post.clubId == widget.clubData["id"]).toList();
  }

  Widget _buildIntroSection() {
    final String name = widget.clubData["name"]?.toString() ?? "이름 없음";
    final String createdAt = widget.clubData["createdAt"]?.toString() ?? "-";
    final String leader = widget.clubData["leader"]?.toString() ?? "-";
    final int memberCount = widget.clubData["memberCount"] as int? ?? 0;
    final int maxCount = widget.clubData["maxMemberCount"] as int? ?? 0;
    final String description = widget.clubData["description"]?.toString() ?? "-";

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
                  Text(
                    "모임장: $leader",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.workspace_premium, color: Colors.amber, size: 20),
                ],
              ),
              Text(
                "인원: $memberCount / $maxCount명",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    final String thumbnailUrl = widget.clubData["thumbnailUrl"]?.toString() ?? "";

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
    return MainLayout(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: const HeaderPage(
          pageTitle: "모임 상세",
          showBackButton: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 썸네일 이미지
              _buildThumbnail(),
              // [yj] 가로 버튼들
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: _isJoined
              ? FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NewPostPage()),
              );
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.edit, color: Colors.white),
          )
              : SizedBox(
            width: 70,
            height: 80,
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
      ),
    );
  }
}

// 일정 탭 위젯
Widget _buildScheduleSection(int clubId) {
  final schedules = dummyClubSchedules[clubId] ?? [];

  if (schedules.isEmpty) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event_busy, size: 60, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              "예정된 일정이 없습니다.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 6),
            Text(
              "첫 모임 일정을 추가해보세요.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: schedules.map((schedule) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(schedule["title"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text("${schedule["date"]} / ${schedule["time"]}", style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.place, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(schedule["location"], style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(schedule["description"]),
              ],
            ),
          ),
        );
      }).toList(),
    ),
  );
}
