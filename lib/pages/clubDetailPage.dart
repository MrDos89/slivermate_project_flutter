import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';

class ClubDetailPage extends StatefulWidget {
  final Map<String, dynamic> clubData;

  const ClubDetailPage({super.key, required this.clubData});

  @override
  State<ClubDetailPage> createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {

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
        return _buildIntroSection(); // 소개 탭
      case 1:
        return const Text("피드 내용 준비 중");
      case 2:
        return const Text("사진 탭 내용");
      case 3:
        return const Text("일정 탭 내용");
      default:
        return const SizedBox.shrink();
    }
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
                "생성일: $createdAt",
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
                  const Icon(Icons.workspace_premium, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    "모임장: $leader",
                    style: const TextStyle(fontSize: 16),
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
        floatingActionButton: SizedBox(
          width: 70,
          height: 80,
          child: FloatingActionButton(
            onPressed: () {
              // 가입 로직 실행
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
    );
  }
}

