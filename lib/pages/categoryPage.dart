import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';

import 'package:slivermate_project_flutter/pages/introducePage.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool showIndoor = false;
  bool showOutdoor = false;
  bool movedToTop = false;

  final Map<String, int> categoryIds = {"실내 활동": 1, "실외 활동": 2};

  final List<Map<String, dynamic>> indoorHobbies = [
    {"id": 1, "name": "뜨개질", "image": "lib/images/knitting.jpg"},
    {"id": 2, "name": "그림", "image": "lib/images/drawing.jpg"},
    {"id": 3, "name": "독서", "image": "lib/images/reading.jpg"},
    {"id": 4, "name": "영화 감상", "image": "lib/images/movie.jpg"},
    {"id": 5, "name": "퍼즐 맞추기", "image": "lib/images/puzzle.jpg"},
    {"id": 6, "name": "요리", "image": "lib/images/cooking.jpg"},
  ];

  final List<Map<String, dynamic>> outdoorHobbies = [
    {"id": 1, "name": "등산", "image": "lib/images/hiking.jpg"},
    {"id": 2, "name": "자전거", "image": "lib/images/cycling.jpg"},
    {"id": 3, "name": "캠핑", "image": "lib/images/camping.jpg"},
    {"id": 4, "name": "낚시", "image": "lib/images/fishing.jpg"},
    {"id": 5, "name": "러닝", "image": "lib/images/running.jpg"},
    {"id": 6, "name": "서핑", "image": "lib/images/surfing.jpg"},
  ];

  void _onCategorySelected(bool isIndoor) {
    setState(() {
      if (movedToTop &&
          ((isIndoor && showIndoor) || (!isIndoor && showOutdoor))) {
        showIndoor = false;
        showOutdoor = false;
        movedToTop = false;
      } else {
        showIndoor = isIndoor;
        showOutdoor = !isIndoor;
        movedToTop = true;
      }
    });
  }

  /// 📌 취미 버튼을 클릭하면 강의 페이지로 이동 (현재는 주석 처리)
  void _onHobbySelected(int categoryId, int hobbyId, String hobbyName) {
    print("선택한 취미: $hobbyName (카테고리 ID: $categoryId, 취미 ID: $hobbyId)");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => IntroducePage(
              category: categoryId == 1 ? "실내" : "실외", // ✅ 실내 / 실외 분류
              subCategory: hobbyName, // ✅ 선택한 취미명
              lectureTitle: "$hobbyName 강의", // ✅ 강의명 설정
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
            73,
          ), // 🔥 원하는 높이 설정 (기본 56 → 150)
          child: AppBar(
            title: const Text(
              "카테고리 선택",
              style: TextStyle(
                color: Colors.white, // 글씨를 흰색으로 변경
                fontWeight: FontWeight.bold,
              ),
            ),
            // centerTitle: true, // 제목 중앙 정렬
            backgroundColor: Colors.transparent, // 배경 투명
            elevation: 0, // 그림자 제거
            flexibleSpace: Container(
              height: 150, // 🔥 AppBar 높이에 맞게 설정
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/images/dnl.jpg"), // 배경 이미지 설정
                  fit: BoxFit.cover, // 화면에 꽉 차도록 설정
                ),
              ),
            ),
          ),
        ),

        body: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              top:
                  movedToTop
                      ? 50
                      : MediaQuery.of(context).size.height / 2 - 120,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCategoryButton(
                        "실내 활동",
                        () => _onCategorySelected(true),
                      ),
                      const SizedBox(width: 20),
                      _buildCategoryButton(
                        "실외 활동",
                        () => _onCategorySelected(false),
                      ),
                    ],
                  ),
                  if (movedToTop) const SizedBox(height: 30),
                ],
              ),
            ),
            Positioned(
              top: movedToTop ? 200 : MediaQuery.of(context).size.height,
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                opacity: movedToTop ? 1.0 : 0.0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 2.0,
                    ),
                    child: Column(
                      children: [
                        if (showIndoor)
                          _buildHobbyGrid(indoorHobbies, categoryIds["실내 활동"]!),
                        if (showOutdoor)
                          _buildHobbyGrid(
                            outdoorHobbies,
                            categoryIds["실외 활동"]!,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String title, VoidCallback onPressed) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 120),
          textStyle: const TextStyle(fontSize: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }

  /// 🔥 취미 카드 버튼을 기존 디자인 유지하면서 그대로 버튼화
  Widget _buildHobbyGrid(List<Map<String, dynamic>> hobbies, int categoryId) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1,
      ),
      itemCount: hobbies.length,
      itemBuilder: (context, index) {
        return _buildHobbyButton(hobbies[index], categoryId);
      },
    );
  }

  /// 🔥 이미지 배경을 유지한 취미 버튼
  Widget _buildHobbyButton(Map<String, dynamic> hobby, int categoryId) {
    return GestureDetector(
      onTap: () => _onHobbySelected(categoryId, hobby["id"], hobby["name"]),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: _getImage(hobby["image"]),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            hobby["name"],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// 📌 이미지가 없으면 기본 이미지 사용
  ImageProvider _getImage(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage("lib/images/default.jpg"); // 기본 이미지 설정
    }
    return AssetImage(path);
  }
}
