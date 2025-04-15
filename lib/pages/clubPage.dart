import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/pages/clubDetailPage.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:slivermate_project_flutter/pages/postPage.dart';
import 'package:slivermate_project_flutter/pages/newClubPage.dart';
import 'package:slivermate_project_flutter/vo/clubVo.dart';

const Map<int, String> categoryNames = {
  1: "실내",
  2: "실외",
};

const Map<int, String> indoorHobbies = {
  1: "뜨개질",
  2: "그림",
  3: "독서",
  4: "영화 감상",
  5: "퍼즐",
  6: "요리",
  7: "통기타",
  8: "당구",
  9: "바둑",
};

const Map<int, String> outdoorHobbies = {
  1: "등산",
  2: "자전거",
  3: "캠핑",
  4: "낚시",
  5: "러닝/마라톤",
  6: "수영",
  7: "골프",
  8: "테니스",
  9: "족구",
};

Map<int, String> regionMap = {
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
        floatingActionButton: SizedBox(
          width: 70,  // ✔ 동그라미 지름
          height: 70,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NewClubPage(),
                ),
              );
            },
            backgroundColor: Colors.green,
            shape: const CircleBorder(), // ✔ 동그라미
            child: const Text(
              "모임\n만들기",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14, // ✔ 글씨 크기 조절
              ),
            ),
          ),
        ),
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

  int toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }


  // final List<String> allCategories = [
  //   "뜨개질",
  //   "그림",
  //   "독서",
  //   "영화감상",
  //   "퍼즐",
  //   "요리",
  //   "통기타",
  //   "당구",
  //   "바둑",
  //   "등산",
  //   "자전거",
  //   "캠핑",
  //   "낚시",
  //   "러닝/마라톤",
  //   "수영",
  //   "골프",
  //   "테니스",
  //   "족구",
  // ];

  List<Map<String, Object?>> clubData = [];
  bool isLoading = true;

  List<ClubVo> allClubs = [];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> fetchClubList() async {
    debugPrint("🟡 fetchClubList 시작");

    final List<ClubVo> serverClubs = await fetchClubsFromServer();

    allClubs = serverClubs;

    setState(() {
      isLoading = true;
    });

    try {
      final List<ClubVo> serverClubs = await fetchClubsFromServer();
      debugPrint("✅ 서버에서 클럽 ${serverClubs.length}개 불러옴");

      final List<Map<String, Object?>> mapped = serverClubs.map((club) {
        final int categoryId = club.clubCategoryId;
        final int subCategoryId = club.clubSubCategoryId;

        final String hobby = categoryId == 1
            ? indoorHobbies[subCategoryId] ?? "기타"
            : outdoorHobbies[subCategoryId] ?? "기타";

        final String categoryType = categoryId == 1 ? "실내" : "실외";

        return {
          "vo": club,
          "id": club.clubId,
          "categoryType": categoryType,
          "category": hobby,
          "name": club.clubName,
          "description": club.clubDesc,
          "leader": club.clubUserId,
          "createdAt": club.clubRegisterDate,
          "thumbnailUrl": club.clubThumbnail,
          "memberCount": club.clubMemberNumber,
          "maxMemberCount": club.clubMemberMax,
        };
      }).toList();

      setState(() {
        clubData = mapped;
        isLoading = false;
      });
    } catch (e, st) {
      debugPrint("❌ 클럽 목록 로딩 실패: $e");
      debugPrint("📌 스택트레이스: $st");

      setState(() {
        isLoading = false;
      });
    }
  }

  List<Widget> _buildCategoryChipRows() {
    final List<String> allCategories = [
      ...indoorHobbies.values,
      ...outdoorHobbies.values,
    ];

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
    final top3 = allClubs.length >= 3
        ? allClubs.sublist(0, 3)
        : allClubs; // 3개 미만이면 있는 만큼만

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "추천 동아리",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            itemCount: top3.length,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final club = top3[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: club.clubThumbnail.isNotEmpty
                          ? NetworkImage(club.clubThumbnail)
                          : const AssetImage('lib/images/club.avif') as ImageProvider,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Color.fromRGBO(0, 0, 0, 0.4),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          club.clubName,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          club.clubDesc,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
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
            children: List.generate(top3.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClubDetailPage(clubVo: club["vo"] as ClubVo),
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 썸네일 이미지
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: club["thumbnailUrl"] != null && (club["thumbnailUrl"] as String).isNotEmpty
                                  ? Image.network(
                                club["thumbnailUrl"] as String,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'lib/images/club.avif',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                                  : Image.asset(
                                'lib/images/club.avif',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // 텍스트 정보
                            Expanded(
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
                                  Text(
                                    club["description"] as String,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
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
          color: const Color(0xFFF5F5F5),
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

