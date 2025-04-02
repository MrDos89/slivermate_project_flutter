import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/pages/clubDetailPage.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

const Map<int, String> regionMap = {
  1: "서울특별시",
  2: "부산광역시",
  3: "대구광역시",
  4: "인천광역시",
  5: "광주광역시",
  6: "대전광역시",
  7: "울산광역시",
  8: "세종특별자치시",
  9: "경기도",
  10: "강원도",
  11: "충청북도",
  12: "충청남도",
  13: "전라북도",
  14: "전라남도",
  15: "경상북도",
  16: "경상남도",
  17: "제주특별자치도",
  18: "울릉도",
};
class ClubPage extends StatelessWidget {
  const ClubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "모임 페이지"),
          //  Container(
          //   height: 70,
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   color: Colors.transparent,
          //   child: const Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         "모임 페이지",
          //         style: TextStyle(
          //           fontSize: 20,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.black,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
        body: const _ClubPage(),
      ),
    );
  }
}

class _ClubPage extends StatefulWidget {
  const _ClubPage({super.key});

  @override
  State<_ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<_ClubPage> {
  List<String> selectedRegions = [];
  List<String> selectedCategories = [];
  int? _selectedRegionId;

  final List<String> allCategories = [
    "뜨개질",
    "그림",
    "독서",
    "영화감상",
    "퍼즐",
    "요리",
    "통기타",
    "당구",
    "바둑",
    "등산",
    "자전거",
    "캠핑",
    "낚시",
    "러닝/마라톤",
    "수영",
    "골프",
    "테니스",
    "족구",
  ];

  List<Map<String, Object>> clubData = [];
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
        "region": "서울특별시",
        "category": "등산",
        "description": "주말마다 서울 근교 등산을 함께해요!",
        "leader": "산개",
        "memberCount": 12,
        "maxMemberCount": 20,
        "createdAt": "2024.05.01",
        "thumbnailUrl": "https://lh3.googleusercontent.com/proxy/r1N3wBQEiaHzWjoASRoNrQd7xeqKzIlD-Mabk-59Dsda1BcBBSyGs--aAWCWqQBPxxVda6I0Jxu1VjrIVGHUltNI6u5VYUoUMigAYeVPPDzX_ecqHtwBkxYbjEJX1eAxPj72GbQU",
      },
      {
        "name": "경기 독서 모임",
        "region": "인천광역시",
        "category": "독서",
        "description": "한 달 한 권 함께 읽고 이야기 나눠요.",
        "leader": "책벌래",
        "memberCount": 9,
        "maxMemberCount": 15,
        "createdAt": "2024.04.20",
        "thumbnailUrl": "https://t1.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/1c8F/image/QQsbiyF9-kBvQasym-Vowm5wk-U.jpg",
      },
      {
        "name": "부산 퍼즐 동호회",
        "region": "부산광역시",
        "category": "퍼즐",
        "description": "퍼즐 좋아하는 분들 모여요!",
        "leader": "퍼즐킹",
        "memberCount": 7,
        "maxMemberCount": 12,
        "createdAt": "2024.03.10",
        "thumbnailUrl": "https://cdn.crowdpic.net/detail-thumb/thumb_d_07D9AF521C33E48CF5A486668B15A779.jpg",
      },
      {
        "name": "서울 테니스 동호회",
        "region": "서울특별시",
        "category": "테니스",
        "description": "테니스 좋아하는 분들 모여요!",
        "leader": "초테",
        "memberCount": 16,
        "maxMemberCount": 25,
        "createdAt": "2024.02.15",
        "thumbnailUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWIHbtHVx1GiQzv3PctdxJCsIr6MpOGgI8rg&s",
      },
    ];


    setState(() {
      clubData = dummyResponse;
      isLoading = false;
    });
  }

  List<Widget> _buildCategoryChipRows() {
    const int rowCount = 2;
    const int itemsPerRow = 9;

    return List.generate(rowCount, (rowIndex) {
      final start = rowIndex * itemsPerRow;
      final end =
      (start + itemsPerRow) <= allCategories.length
          ? start + itemsPerRow
          : allCategories.length;

      final rowItems = allCategories.sublist(start, end);

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children:
          rowItems.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildFilterChip(
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
              ),
            );
          }).toList(),
        ),
      );
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
      color: const Color(0xFFF5F5F5),
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
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        // const SizedBox(
        //   width: 60, // 제목 너비 고정
        //   child: Text(
        //     "지역",
        //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: RegionDropdown(
            value: _selectedRegionId,
            onChanged: (value) {
              setState(() {
                _selectedRegionId = value;
              });
            },
          ),
        ),
        // ],
        // ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 60,
              child: Text(
                "카테고리",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 40, // 2줄 필터 높이
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _buildCategoryChipRows(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // List<Widget> _buildRegionChips() { // 지역 필터 리스트 함수
  //   return allRegions.map((region) {
  //     return Padding(
  //       padding: const EdgeInsets.only(right: 8.0),
  //       child: _buildFilterChip(
  //         region,
  //         selectedRegions.contains(region),
  //             (bool value) {
  //           setState(() {
  //             if (value) {
  //               selectedRegions.add(region);
  //             } else {
  //               selectedRegions.remove(region);
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   }).toList();
  // }


  Widget _buildFilterChip(String label,
      bool selected,
      Function(bool) onSelected,) {
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
      selectedColor: const Color(0xFF88D498),
      // 연초록
      backgroundColor: const Color(0xFFE2F0CB),
      // 기본 배경
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
        const Text(
          "추천 동아리",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // const SizedBox(height: 5),
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
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
                      // const SizedBox(height: 10),
                      Text(
                        "추천 동아리 ${index + 1}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Text(
                        "동아리 정보 자리",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 5),
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
                  color:
                  _currentPage == index
                      ? Colors.blueAccent
                      : Colors.grey[300],
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

      final selectedRegionName = regionMap[_selectedRegionId];
      final regionMatch = _selectedRegionId == null ||
          region == selectedRegionName;
      final categoryMatch =
          selectedCategories.isEmpty || selectedCategories.contains(category);

      return regionMatch && categoryMatch;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "동아리 리스트",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 300,
          child: ListView(
            children: [
              ...filtered.map((club) {
                return InkWell(
                  onTap: () {
                    print("클럽 데이터 확인: $club");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClubDetailPage(clubData: club),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              club["name"] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${club["region"]} · ${club["category"]}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Text(club["description"] as String),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}

// [yj] 지역 선택 위젯
class RegionDropdown extends StatelessWidget {
  final int? value;
  final void Function(int?) onChanged;

  const RegionDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<int?>(
      isExpanded: true,
      value: value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        labelText: '지역 선택',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
      items: [
        const DropdownMenuItem<int?>(
          value: null, // null 값 허용
          child: Text("전체 지역"),
        ),
        ...regionMap.entries.map(
              (entry) => DropdownMenuItem<int?>(
            value: entry.key,
            child: Text(entry.value),
          ),
        ),
      ],
      onChanged: onChanged,
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
