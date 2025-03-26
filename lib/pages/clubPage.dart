import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';

class ClubPage extends StatelessWidget {
  const ClubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("동아리 페이지"),
          backgroundColor: const Color(0xFF044E00).withAlpha(128),
          foregroundColor: Colors.white,
        ),
        body: const _ClubPage(),
      ),
    );
  }
}
// "준비중" 다이얼로그 함수 (기존 코드)
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

class _ClubPage extends StatefulWidget {
  const _ClubPage({super.key});

  @override
  State<_ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<_ClubPage> {
  List<String> selectedRegions = [];
  List<String> selectedCategories = [];

  final List<String> allRegions = ["서울", "경기", "부산"];
  final List<String> allCategories = ["운동", "독서", "게임"];

  List<Map<String, String>> clubData = [];
  bool isLoading = true;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> fetchClubList() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500)); // 서버 대기 시뮬레이션

    final dummyResponse = [
      {
        "name": "서울 등산 동아리",
        "region": "서울",
        "category": "운동",
        "description": "주말마다 서울 근교 등산을 함께해요!",
      },
      {
        "name": "경기 독서 모임",
        "region": "경기",
        "category": "독서",
        "description": "한 달 한 권 함께 읽고 이야기 나눠요.",
      },
      {
        "name": "부산 보드게임 동호회",
        "region": "부산",
        "category": "게임",
        "description": "보드게임 좋아하는 분들 모여요!",
      },
    ];

    setState(() {
      clubData = dummyResponse;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchClubList(); // 서버처럼 더미 데이터 받아오기
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5), // 싱그러운 연초록 배경
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilters(),
            const SizedBox(height: 32),
            _buildRecommendedClubs(),
            const SizedBox(height: 32),
            _buildClubList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 60, // 제목 너비 고정
              child: Text("지역", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allRegions.map((region) {
                  return _buildFilterChip(
                    region,
                    selectedRegions.contains(region),
                        (bool value) {
                      setState(() {
                        if (value) {
                          selectedRegions.add(region);
                        } else {
                          selectedRegions.remove(region);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 60,
              child: Text("카테고리", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allCategories.map((category) {
                  return _buildFilterChip(
                    category,
                    selectedCategories.contains(category),
                        (bool value) {
                      setState(() {
                        if (value) {
                          selectedCategories.add(category);
                        } else {
                          selectedCategories.remove(category);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool selected, Function(bool) onSelected) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : const Color(0xFF1E5631),
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: const Color(0xFF88D498), // 연초록
      backgroundColor: const Color(0xFFE2F0CB), // 기본 배경
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? const Color(0xFF379683) : Colors.transparent,
          width: 1.0,
        ),
      ),
    );
  }

  Widget _buildRecommendedClubs() {
    int pageCount = 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("추천 동아리", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            itemCount: pageCount,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, size: 40, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text("추천 동아리 ${index + 1}", style: const TextStyle(fontSize: 16)),
                      const Text("동아리 정보 자리", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(pageCount, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.blueAccent : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildClubList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filtered = clubData.where((club) {
      final region = club["region"] ?? "";
      final category = club["category"] ?? "";

      final regionMatch = selectedRegions.isEmpty || selectedRegions.contains(region);
      final categoryMatch = selectedCategories.isEmpty || selectedCategories.contains(category);

      return regionMatch && categoryMatch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("동아리 리스트", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...filtered.map((club) {
          return SizedBox(
            width: double.infinity, // 🔹 와이드하게 꽉 채우기
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(club["name"]!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("${club["region"]} · ${club["category"]}", style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(club["description"]!),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

// Widget _buildRecommendedClubs() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const Text(
//         "추천 동아리",
//         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//       const SizedBox(height: 12),
//       SizedBox(
//         height: 200,
//         child: PageView.builder(
//           itemCount: 3, // 더미 3개
//           controller: PageController(viewportFraction: 1), // 꽉 채우기
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.star, size: 40, color: Colors.grey[400]),
//                     const SizedBox(height: 12),
//                     Text("추천 동아리 ${index + 1}", style: const TextStyle(fontSize: 16)),
//                     const Text("동아리 정보 자리", style: TextStyle(color: Colors.grey)),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     ],
//   );
// }
