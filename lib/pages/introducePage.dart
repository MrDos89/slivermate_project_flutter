import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slivermate_project_flutter/vo/lessonVo.dart';

// 🔥 카테고리 ID를 문자열로 변환
const Map<int, String> categoryNames = {1: "실내", 2: "실외"};

// 🔥 취미 ID를 문자열로 변환 (카테고리별로 따로 저장)
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

class IntroducePage extends StatefulWidget {
  LessonVo? lesson;
  int lessonCategory;
  int lessonSubCategory;
  UserVo? dummyUser;

  IntroducePage({
    super.key,
    required this.lessonCategory,
    required this.lessonSubCategory,
    required this.dummyUser,
  }) {
    print(
      "IntroducePage 찍힌 카데고리 번호: (카테고리 ID: $lessonCategory, 취미 ID: $lessonSubCategory)",
    );
  }

  @override
  _IntroducePageState createState() => _IntroducePageState();
}

class _IntroducePageState extends State<IntroducePage> {
  late YoutubePlayerController _controller;
  LessonVo? lesson;

  // static const String apiEndpoint =
  //     "http://13.125.197.66:18090/api/lesson/sc/${widget.lesson.lessonCategory}/${lessonSubCategory}"; // 🔥 서버 주소
  // final Dio dio = Dio();

  // 더미 데이터 (서버 데이터 없을 시 사용)
  // final LessonVO dummyLesson = LessonVO(
  //   lessonId: 0,
  //   userId: 101,
  //   lessonName: "기초 요가 스트레칭",
  //   lessonDesc: "기초적인 요가 동작을 통해 스트레칭 하는 법을 배워봅시다.",
  //   lessonCategory: 1,
  //   lessonSubCategory: 2,
  //   lessonFreeLecture: "https://youtu.be/Ei3eoqXmkjU?si=W60TzlwbXhJErL4F",
  //   lessonCostLecture: "",
  //   lessonThumbnail: "",
  //   lessonPrice: 15000,
  //   registerDate: "2024-03-10",
  //   isHidden: false,
  //   updDate: "2024-03-10",
  //   userName: "User #101",
  //   userThumbnail: "assets/images/instructor.png",
  // );

  // @override
  // void initState() {
  //   print("야 initState 들어간다");
  //   super.initState();
  //   fetchLessonData(); // ✅ API 호출 (초기에는 값이 없을 수도 있음)
  //   print("🟢 IntroducePage initState() 실행됨. dummyUser: ${widget.dummyUser?.userName}, ${widget.dummyUser?.email}");
  // }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: '', // 기본값 (오류 방지)
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
    fetchLessonData(); // ✅ 데이터 가져오기
      print("🟢 IntroducePage initState() 실행됨. dummyUser: ${widget.dummyUser?.userName}, ${widget.dummyUser?.email}");

  }


  // ✅ lessonCategory와 lessonSubCategory가 설정된 후 API 호출
  void updateCategory(int category, int subCategory) {
    setState(() {
      widget.lessonCategory = category;
      widget.lessonSubCategory = subCategory;
    });

    print(
      "🎯 [카테고리 업데이트] lessonCategory: ${widget.lessonCategory}, lessonSubCategory: ${widget.lessonSubCategory}",
    );

    // ✅ 값이 설정된 후 API 호출
    fetchLessonData();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchLessonData(0); // 데이터 불러오기
  // }

  // ✅ API 데이터 가져오기
  Future<void> fetchLessonData() async {
    final fetchedLesson = await LessonService.fetchLessonData(
      widget.lessonCategory,
      widget.lessonSubCategory,
    );

    if (fetchedLesson != null) {
      setState(() {
        lesson = fetchedLesson;
        if (lesson != null && lesson!.lessonFreeLecture.isNotEmpty) {
          initializeYoutubePlayer(lesson!.lessonFreeLecture);
        }
      });
    } else {
      print("❌ 강의 데이터를 가져오지 못함.");
    }
  }



  void initializeYoutubePlayer(String youtubeUrl) {
    final videoId = YoutubePlayer.convertUrlToId(youtubeUrl) ?? "";
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
    setState(() {}); // ✅ UI 갱신 추가
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("[IntroducePage] 🟢 dummyUser 값: ${widget.dummyUser?.userName}, ${widget.dummyUser?.email}");

    if (widget.dummyUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // ✅ 데이터 로딩 중 표시
      );
    }

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("강의 로딩 중...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller),
      builder: (context, player) {
        return MainLayout(
          showPaymentButton: lesson != null,
          lesson: lesson,
          dummyUser: widget.dummyUser,
          child: Scaffold(
            backgroundColor: const Color(0xFFD6FFDC).withOpacity(0.9),
            appBar: AppBar(
                backgroundColor: const Color(0xFF044E00).withOpacity(0.5), // 실외 (연녹색)
              automaticallyImplyLeading: false,
              title: lesson == null
                  ? const Text("강의 로딩 중...") // ✅ lesson이 null이면 기본 텍스트 표시
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${categoryNames[lesson!.lessonCategory] ?? "알 수 없음"} / '
                    '${lesson!.lessonCategory == 1 ? indoorHobbies[lesson!.lessonSubCategory] : outdoorHobbies[lesson!.lessonSubCategory] ?? "알 수 없음"}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson!.lessonName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                        color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3.2,
                    decoration: _boxDecorationWithShadow(),
                    child: player, // 여기에 player 삽입
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: _boxDecorationWithShadow(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 🔥 이미지를 텍스트와 묶어주는 Row
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(lesson!.userThumbnail),
                            ),
                            const SizedBox(width: 8), // 이 값으로 간격 조정 가능
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lesson!.userName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  lesson!.getFormattedDate(), // ✅ 변환된 날짜 표시
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ), // 🔥 이미지와 강사정보 묶는 Row의 끝

                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.wonSign,
                              color: Color(0xFF077A00),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              lesson!.lessonPrice.toString(),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF077A00),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      decoration: _boxDecorationWithShadow(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📖 강의 설명',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF077A00),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                lesson!.lessonDesc,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 📌 아래쪽에만 그림자 적용하는 BoxDecoration
  BoxDecoration _boxDecorationWithShadow() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        const BoxShadow(
          color: Colors.black26,
          blurRadius: 6,
          spreadRadius: 0.8,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}
