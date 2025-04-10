import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';

import 'package:slivermate_project_flutter/pages/introducePage.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';

import 'package:video_player/video_player.dart';
import 'dart:math';
import 'package:slivermate_project_flutter/widgets/LectureLoadingOverlay.dart';
import 'package:slivermate_project_flutter/vo/categoryVo.dart';

import 'package:slivermate_project_flutter/components/headerPage.dart';

class CategoryPage extends StatefulWidget {
  final UserVo? userVo;
  const CategoryPage({super.key, required this.userVo});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // late VideoPlayerController _controller;
  bool showIndoor = false;
  bool showOutdoor = false;
  bool movedToTop = false;
  bool showGrid = false; //  추가: 취미 그리드가 표시될 때 true
  bool isLoading = false;

  List<CategoryVo> categories = []; // 카테고리Vo 저장
  // 로딩 상태 변수 추가

  // final Map<String, int> categoryIds = {"실내 활동": 1, "실외 활동": 2};
  //
  // final List<Map<String, dynamic>> indoorHobbies = [
  //   {"id": 1, "name": "뜨개질", "image": "lib/images/knitting.jpg"},
  //   {"id": 2, "name": "그림", "image": "lib/images/drawing.jpg"},
  //   {"id": 3, "name": "독서", "image": "lib/images/reading.jpg"},
  //   {"id": 4, "name": "영화 감상", "image": "lib/images/movie.jpg"},
  //   {"id": 5, "name": "퍼즐", "image": "lib/images/puzzle.jpg"},
  //   {"id": 6, "name": "요리", "image": "lib/images/cooking.jpg"},
  //   {"id": 7, "name": "통기타", "image": "lib/images/guitar.jpg"},
  //   {"id": 8, "name": "당구", "image": "lib/images/billiards.jpg"},
  //   {"id": 9, "name": "바둑", "image": "lib/images/go.jpg"},
  // ];
  //
  // final List<Map<String, dynamic>> outdoorHobbies = [
  //   {"id": 1, "name": "등산", "image": "lib/images/hiking.jpg"},
  //   {"id": 2, "name": "자전거", "image": "lib/images/cycling.jpg"},
  //   {"id": 3, "name": "캠핑", "image": "lib/images/camping.jpg"},
  //   {"id": 4, "name": "낚시", "image": "lib/images/fishing.jpg"},
  //   {"id": 5, "name": "러닝/마라톤", "image": "lib/images/running.jpg"},
  //   {"id": 6, "name": "수영", "image": "lib/images/surfing.jpg"},
  //   {"id": 7, "name": "골프", "image": "lib/images/golf.jpg"},
  //   {"id": 8, "name": "테니스", "image": "lib/images/tennis.jpg"},
  //   {"id": 9, "name": "족구", "image": "lib/images/foot.jpg"},
  // ];

  //  (추가됨) 사용할 영상 목록
  // final List<String> videoPaths = [
  //   "lib/images/skan.mp4",
  //   "lib/images/skan04.mp4",
  //   "lib/images/skan09.mp4",
  // ];

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.asset("lib/images/skan.mp4") //  추가
  //     // _controller = VideoPlayerController.asset("lib/animations/back.mp4") //  추가
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
    _initializeVideo(); //  (추가됨) 초기 영상도 랜덤하게 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("[CategoryPage]로 전달된 유저 정보: ${widget.dummyUser?.userName}, ${widget.dummyUser?.email}");
    });
  }

  ///  (추가됨) 랜덤한 영상 선택 함수
  String _getRandomVideoPath() {
    final random = Random();
    return videoPaths[random.nextInt(videoPaths.length)];
  }

  ///  (추가됨) 배경 영상 초기화
  void _initializeVideo() {
    _controller = VideoPlayerController.asset(_getRandomVideoPath())
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  ///  (추가됨) 배경 클릭 시 랜덤 영상으로 변경
  void _changeVideo() {
    setState(() {
      _controller.dispose(); // 기존 영상 해제
      _initializeVideo(); // 새 랜덤 영상 설정
    });
  }
   */

  // int? lastPlayedIndex; // 마지막 재생된 영상 인덱스 저장

  /// "준비중입니다" 다이얼로그 띄우기
  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("준비중입니다"),
          content: const Text("해당 기능은 현재 준비중입니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  ///  중복되지 않는 랜덤 영상 선택
  // String _getRandomVideoPath() {
  //   final random = Random();
  //   List<String> availableVideos = [...videoPaths];
  //
  //   if (lastPlayedIndex != null) {
  //     availableVideos.removeAt(lastPlayedIndex!);
  //   }
  //
  //   int newIndex = random.nextInt(availableVideos.length);
  //   lastPlayedIndex = videoPaths.indexOf(availableVideos[newIndex]);
  //
  //   return availableVideos[newIndex];
  // }

  @override
  void initState() {
    super.initState();
    // _initializeVideo();

    isLoading = true; // 로딩 시작
    fetchCategories().then((_) {
      setState(() {
        isLoading = false; // 로딩 종료
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(
        "[CategoryPage] dummyUser 확인: ${widget.userVo?.userName}, ${widget.userVo?.email}",
      );
    });
  }

  // API를 통해 데이터를 불러오는 메서드
  Future<void> fetchCategories() async {
    final fetchedCategories = await CategoryService.fetchCategories();

    if (fetchedCategories.isNotEmpty) {
      setState(() {
        categories = fetchedCategories; // 데이터가 정상적으로 오면 저장
      });
    } else {
      print(" 카테고리 데이터를 가져오지 못했습니다.");
    }
  }

  ///  배경 영상 초기화
  // void _initializeVideo() {
  //   String nextVideo = _getRandomVideoPath();
  //   _controller = VideoPlayerController.asset(nextVideo)
  //     ..initialize().then((_) {
  //       setState(() {});
  //       _controller.setLooping(true);
  //       _controller.play();
  //     });
  // }

  ///  배경 클릭 시 랜덤 영상 변경 (중복 방지)
  // void _changeVideo() {
  //   setState(() {
  //     _controller.dispose();
  //     String nextVideo = _getRandomVideoPath();
  //     _controller = VideoPlayerController.asset(nextVideo)
  //       ..initialize().then((_) {
  //         setState(() {});
  //         _controller.setLooping(true);
  //         _controller.play();
  //       });
  //   });
  // }

  @override
  void dispose() {
    // _controller.dispose(); //  추가
    super.dispose();
  }

  void _onCategorySelected(bool isIndoor) {
    setState(() {
      if (movedToTop &&
          ((isIndoor && showIndoor) || (!isIndoor && showOutdoor))) {
        showIndoor = false;
        showOutdoor = false;
        movedToTop = false;
        showGrid = false; //  취미 버튼이 사라지면 배경도 투명하게 유지
      } else {
        showIndoor = isIndoor;
        showOutdoor = !isIndoor;
        movedToTop = true;
        showGrid = true; //  취미 버튼이 나타나면 배경을 흰색으로 변경
      }
    });
  }

  /// 📌 취미 버튼을 클릭하면 강의 페이지로 이동 (현재는 주석 처리)
  void _onHobbySelected(
    int categoryId,
    int subCategoryId,
    String hobbyName,
  ) async {
    print("선택한 취미: $hobbyName (카테고리 ID: $categoryId, 취미 ID: $subCategoryId)");

    setState(() {
      isLoading = true; //  로딩 시작
    });

    await Future.delayed(Duration(milliseconds: 500)); //  잠시 로딩 표시

    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => IntroducePage(
                lessonCategory: categoryId, //  실내 / 실외 분류
                lessonSubCategory: subCategoryId, //  선택한 취미명
                userVo: widget.userVo,
              ),
          settings: RouteSettings(arguments: widget.userVo),
        ),
      );

      if (mounted) {
        setState(() {
          isLoading = false; //  로딩 종료
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: LectureLoadingOverlay(
        isLoading: isLoading,
        child: MainLayout(
          userVo: widget.userVo,
          child: Column(
            children: [
              // AppBar + TabBar
              HeaderPage(pageTitle: "강의 페이지"),
              // 탭 컨텐츠 (TabBarView)
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildCategoryTab(),
                    const Center(child: Text("강의 페이지 준비 중입니다")),
                    const Center(child: Text("내 강의 페이지 준비 중입니다")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab() {
    return Stack(
      children: [
        // 카테고리 선택 버튼
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          top: movedToTop ? 70 : MediaQuery.of(context).size.height / 2 - 167,
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
                    Icons.home,
                  ),
                  const SizedBox(width: 20),
                  _buildCategoryButton(
                    "실외 활동",
                    () => _onCategorySelected(false),
                    Icons.park,
                  ),
                ],
              ),
              if (movedToTop) const SizedBox(height: 30),
            ],
          ),
        ),

        // 취미 그리드
        Positioned(
          top: movedToTop ? 190 : MediaQuery.of(context).size.height,
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
                    if (showIndoor) _buildHobbyGrid(1),
                    if (showOutdoor) _buildHobbyGrid(2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(
    String title,
    VoidCallback onPressed,
    IconData icon,
  ) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // backgroundColor: const Color(0xFFE6E6FA), //  버튼 배경색 변경
          // backgroundColor: Colors.white.withOpacity(0.7),
          // backgroundColor: Color(0xFF000000).withOpacity(0.4),
          // backgroundColor: Color(0xFF00A8A8).withOpacity(0.6),
          backgroundColor: Color(0xFF044E00).withAlpha(128),
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
                fontFamily: 'GowunDodum',
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

  ///  취미 카드 버튼을 기존 디자인 유지하면서 그대로 버튼화
  Widget _buildHobbyGrid(int categoryId) {
    final hobbyList =
        categories
            .where((category) => category.categoryId == categoryId)
            .toList();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1,
      ),
      itemCount: hobbyList.length,
      itemBuilder: (context, index) {
        return _buildHobbyButton(hobbyList[index]);
      },
    );
  }

  ///  이미지 배경을 유지한 취미 버튼
  Widget _buildHobbyButton(CategoryVo hobby) {
    return GestureDetector(
      onTap:
          () => _onHobbySelected(
            hobby.categoryId,
            hobby.subCategoryId,
            hobby.subCategoryName,
          ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: _getImage(hobby.image),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(64),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            hobby.subCategoryName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'SDSam',
            ),
          ),
        ),
      ),
    );
  }

  ///  이미지가 없으면 기본 이미지 사용
  ImageProvider _getImage(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage("lib/images/cofl.jpg"); // 기본 이미지 설정
    }
    return AssetImage("lib/images/$path.jpg");
  }
}
