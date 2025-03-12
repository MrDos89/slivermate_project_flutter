import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool showIndoor = false;
  bool showOutdoor = false;
  bool movedToTop = false; // 버튼이 상단으로 이동했는지 여부

  final List<Map<String, String>> indoorHobbies = [
    {"name": "뜨개질", "image": "lib/images/knitting.jpg"},
    {"name": "그림", "image": "lib/images/drawing.jpg"},
    {"name": "독서", "image": "lib/images/reading.jpg"},
    {"name": "영화 감상", "image": "lib/images/movie.jpg"},
    {"name": "퍼즐 맞추기", "image": "lib/images/puzzle.jpg"},
    {"name": "요리", "image": "lib/images/cooking.jpg"},
  ];

  final List<Map<String, String>> outdoorHobbies = [
    {"name": "등산", "image": "lib/images/hiking.jpg"},
    {"name": "자전거", "image": "lib/images/cycling.jpg"},
    {"name": "캠핑", "image": "lib/images/camping.jpg"},
    {"name": "낚시", "image": "lib/images/fishing.jpg"},
    {"name": "러닝", "image": "lib/images/running.jpg"},
    {"name": "서핑", "image": "lib/images/surfing.jpg"},
  ];

  void _onCategorySelected(bool isIndoor) {
    setState(() {
      if (movedToTop &&
          ((isIndoor && showIndoor) || (!isIndoor && showOutdoor))) {
        // 두 번 눌렀을 때 다시 접기
        showIndoor = false;
        showOutdoor = false;
        movedToTop = false;
      } else {
        showIndoor = isIndoor;
        showOutdoor = !isIndoor;
        movedToTop = true; // 버튼을 상단으로 이동
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text("카테고리 선택")),
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              top:
                  movedToTop
                      ? 50
                      : MediaQuery.of(context).size.height / 2 -
                          120, // 버튼 위치 조정
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCategoryButton(
                    "실내 활동",
                    () => _onCategorySelected(true),
                  ),
                  const SizedBox(height: 15), // 큰버튼 간격 조정
                  _buildCategoryButton(
                    "실외 활동",
                    () => _onCategorySelected(false),
                  ),
                  if (movedToTop)
                    const SizedBox(height: 30), // 큰버튼과 카드 버튼 사이 간격 추가
                ],
              ),
            ),
            Positioned(
              top:
                  movedToTop
                      ? 200
                      : MediaQuery.of(context).size.height, // 카드 위로 조정
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                opacity: movedToTop ? 1.0 : 0.0, // 애니메이션 효과 추가
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 2.0,
                    ), // 카드와 버튼 간격 조정
                    child: Column(
                      children: [
                        if (showIndoor) _buildHobbyGrid(indoorHobbies),
                        if (showOutdoor) _buildHobbyGrid(outdoorHobbies),
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
          minimumSize: const Size(220, 55), // 큰버튼 크기 유지
          textStyle: const TextStyle(fontSize: 18),
        ),
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }

  Widget _buildHobbyGrid(List<Map<String, String>> hobbies) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 한 줄에 3개씩
        crossAxisSpacing: 15, // 카드 간격 추가
        mainAxisSpacing: 15, // 카드 간격 추가
        childAspectRatio: 1, // 정사각형 카드
      ),
      itemCount: hobbies.length,
      itemBuilder: (context, index) {
        return _buildHobbyCard(hobbies[index]);
      },
    );
  }

  Widget _buildHobbyCard(Map<String, String> hobby) {
    return Container(
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
          hobby["name"]!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// 📌 이미지가 없으면 기본 이미지 사용하도록 수정
  ImageProvider _getImage(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage("lib/images/default.jpg"); // 기본 이미지
    }
    return AssetImage(path);
  }
}
