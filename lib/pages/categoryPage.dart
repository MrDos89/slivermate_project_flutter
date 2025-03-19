import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';

import 'package:slivermate_project_flutter/pages/introducePage.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';

import 'package:video_player/video_player.dart';
import 'dart:math';

class CategoryPage extends StatefulWidget {
  final UserVo? dummyUser;
  const CategoryPage({super.key, required this.dummyUser});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late VideoPlayerController _controller;
  bool showIndoor = false;
  bool showOutdoor = false;
  bool movedToTop = false;
  bool showGrid = false; // ✅ 추가: 취미 그리드가 표시될 때 true

  final Map<String, int> categoryIds = {"실내 활동": 1, "실외 활동": 2};

  final List<Map<String, dynamic>> indoorHobbies = [
    {"id": 1, "name": "뜨개질", "image": "lib/images/knitting.jpg"},
    {"id": 2, "name": "그림", "image": "lib/images/drawing.jpg"},
    {"id": 3, "name": "독서", "image": "lib/images/reading.jpg"},
    {"id": 4, "name": "영화 감상", "image": "lib/images/movie.jpg"},
    {"id": 5, "name": "퍼즐", "image": "lib/images/puzzle.jpg"},
    {"id": 6, "name": "요리", "image": "lib/images/cooking.jpg"},
    {"id": 7, "name": "통기타", "image": "lib/images/guitar.jpg"},
    {"id": 8, "name": "당구", "image": "lib/images/billiards.jpg"},
    {"id": 9, "name": "바둑", "image": "lib/images/go.jpg"},
  ];

  final List<Map<String, dynamic>> outdoorHobbies = [
    {"id": 1, "name": "등산", "image": "lib/images/hiking.jpg"},
    {"id": 2, "name": "자전거", "image": "lib/images/cycling.jpg"},
    {"id": 3, "name": "캠핑", "image": "lib/images/camping.jpg"},
    {"id": 4, "name": "낚시", "image": "lib/images/fishing.jpg"},
    {"id": 5, "name": "러닝/마라톤", "image": "lib/images/running.jpg"},
    {"id": 6, "name": "수영", "image": "lib/images/surfing.jpg"},
    {"id": 7, "name": "골프", "image": "lib/images/golf.jpg"},
    {"id": 8, "name": "테니스", "image": "lib/images/tennis.jpg"},
    {"id": 9, "name": "족구", "image": "lib/images/foot.jpg"},
  ];

  // 🔹 (추가됨) 사용할 영상 목록
  final List<String> videoPaths = [
    "lib/images/skan.mp4",
    "lib/images/skan04.mp4",
    "lib/images/skan09.mp4",
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.asset("lib/images/skan.mp4") // ✅ 추가
  //     // _controller = VideoPlayerController.asset("lib/animations/back.mp4") // ✅ 추가
  //     ..initialize().then((_) {
  //       setState(() {});
  //       _controller.setLooping(true);
  //       _controller.play();
  //     });
  // }

  /*
  @override
  void initState() {
    super.initState();
    _initializeVideo(); // 🔹 (추가됨) 초기 영상도 랜덤하게 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("[CategoryPage]로 전달된 유저 정보: ${widget.dummyUser?.userName}, ${widget.dummyUser?.email}");
    });
  }

  /// 🔹 (추가됨) 랜덤한 영상 선택 함수
  String _getRandomVideoPath() {
    final random = Random();
    return videoPaths[random.nextInt(videoPaths.length)];
  }

  /// 🔹 (추가됨) 배경 영상 초기화
  void _initializeVideo() {
    _controller = VideoPlayerController.asset(_getRandomVideoPath())
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  /// 🔹 (추가됨) 배경 클릭 시 랜덤 영상으로 변경
  void _changeVideo() {
    setState(() {
      _controller.dispose(); // 기존 영상 해제
      _initializeVideo(); // 새 랜덤 영상 설정
    });
  }
   */

  int? lastPlayedIndex; // 마지막 재생된 영상 인덱스 저장

  /// 🔹 중복되지 않는 랜덤 영상 선택
  String _getRandomVideoPath() {
    final random = Random();
    List<String> availableVideos = [...videoPaths];

    if (lastPlayedIndex != null) {
      availableVideos.removeAt(lastPlayedIndex!);
    }

    int newIndex = random.nextInt(availableVideos.length);
    lastPlayedIndex = videoPaths.indexOf(availableVideos[newIndex]);

    return availableVideos[newIndex];
  }

  @override
  void initState() {
    super.initState();
    _initializeVideo();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("[CategoryPage] dummyUser 확인: ${widget.dummyUser?.userName}, ${widget.dummyUser?.email}");
    });
  }

  /// 🔹 배경 영상 초기화
  void _initializeVideo() {
    String nextVideo = _getRandomVideoPath();
    _controller = VideoPlayerController.asset(nextVideo)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  /// 🔹 배경 클릭 시 랜덤 영상 변경 (중복 방지)
  void _changeVideo() {
    setState(() {
      _controller.dispose();
      String nextVideo = _getRandomVideoPath();
      _controller = VideoPlayerController.asset(nextVideo)
        ..initialize().then((_) {
          setState(() {});
          _controller.setLooping(true);
          _controller.play();
        });
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // ✅ 추가
    super.dispose();
  }

  void _onCategorySelected(bool isIndoor) {
    setState(() {
      if (movedToTop &&
          ((isIndoor && showIndoor) || (!isIndoor && showOutdoor))) {
        showIndoor = false;
        showOutdoor = false;
        movedToTop = false;
        showGrid = false; // ✅ 취미 버튼이 사라지면 배경도 투명하게 유지
      } else {
        showIndoor = isIndoor;
        showOutdoor = !isIndoor;
        movedToTop = true;
        showGrid = true; // ✅ 취미 버튼이 나타나면 배경을 흰색으로 변경
      }
    });
  }

  /// 📌 취미 버튼을 클릭하면 강의 페이지로 이동 (현재는 주석 처리)
  void _onHobbySelected(int categoryId, int subCategoryId, String hobbyName) {
    print("선택한 취미: $hobbyName (카테고리 ID: $categoryId, 취미 ID: $subCategoryId)");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => IntroducePage(
              lessonCategory: categoryId, // ✅ 실내 / 실외 분류
              lessonSubCategory: subCategoryId, // ✅ 선택한 취미명
              dummyUser: widget.dummyUser,
            ),
        settings: RouteSettings(arguments: widget.dummyUser)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: GestureDetector(
        onTap: _changeVideo, // 🔹 배경 클릭하면 랜덤 영상 변경
        child: Stack(
          children: [
            /// 🎥 **배경 영상 추가 (기존 유지)**
            Positioned.fill(
              child:
                  _controller.value.isInitialized
                      ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: VideoPlayer(_controller),
                        ),
                      )
                      : Container(color: Colors.black),
            ),

            /// 🎨 **영상 위에 반투명한 오버레이 추가**
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              color: Colors.white.withOpacity(showGrid ? 0.6 : 0.2), // ✅ 투명도 조절
            ),

            /// 🌟 **기존 Scaffold 유지**
            Scaffold(
              backgroundColor: Colors.transparent, // ✅ 배경 투명하게 설정
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(73),
                child: AppBar(
                  leading: null, // 뒤로가기 버튼 지우기
                  automaticallyImplyLeading: false,
                  centerTitle: false, // 🔥 제목을 왼쪽 정렬로 유지**
                  title: Transform.translate(
                    offset: const Offset(0, 8), // 🔥 아래로 6픽셀 이동 (조절 가능)
                    child: const Text(
                      "카테고리 선택",
                      style: TextStyle(
                        // color: Color(0xFF4E342E), // ✅ 기존 글씨색 유지
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // backgroundColor: Color(0xFFE6E6FA), // ✅ 배경색 설정
                  // backgroundColor: Colors.white.withOpacity(0.7),
                  backgroundColor: Color(0xFF044E00).withOpacity(0.5),
                  elevation: 0, // 그림자 제거
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
                            : MediaQuery.of(context).size.height / 2 - 167,
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
                              Icons.home, // ✅ 실내 활동 아이콘
                            ),
                            const SizedBox(width: 20),
                            _buildCategoryButton(
                              "실외 활동",
                              () => _onCategorySelected(false),
                              Icons.park, // ✅ 실외 활동 아이콘
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
                                _buildHobbyGrid(
                                  indoorHobbies,
                                  categoryIds["실내 활동"]!,
                                ),
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
          ],
        ),
      ),
    ); // ✅ `MainLayout`의 닫는 `)` 추가
  }

  Widget _buildCategoryButton(
    String title,
    VoidCallback onPressed,
    IconData icon,
  ) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // backgroundColor: const Color(0xFFE6E6FA), // ✅ 버튼 배경색 변경
          // backgroundColor: Colors.white.withOpacity(0.7),
          // backgroundColor: Color(0xFF000000).withOpacity(0.4),
          // backgroundColor: Color(0xFF00A8A8).withOpacity(0.6),
          backgroundColor: Color(0xFF044E00).withOpacity(0.6),
          minimumSize: const Size(150, 120),
          textStyle: const TextStyle(fontSize: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 36, // 아이콘 크기 조절
            ),
            const SizedBox(height: 8), // 아이콘과 텍스트 간격
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
          ],
        ),
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
            color: Colors.black.withOpacity(0.25),
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
      return const AssetImage("lib/images/cofl.jpg"); // 기본 이미지 설정
    }
    return AssetImage(path);
  }
}
