import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slivermate_project_flutter/vo/lessonVo.dart';
import 'package:dio/dio.dart';

class IntroducePage extends StatefulWidget {
  final String category;
  final String subCategory;
  final String lectureTitle;
  final String youtubeUrl;

  const IntroducePage({
    super.key,
    this.category = "실내",
    this.subCategory = "요가",
    this.lectureTitle = "기초 요가 스트레칭",
    this.youtubeUrl = "https://youtu.be/Ei3eoqXmkjU?si=W60TzlwbXhJErL4F",
  });

  @override
  _IntroducePageState createState() => _IntroducePageState();
}

class _IntroducePageState extends State<IntroducePage> {
  late YoutubePlayerController _controller;
  LessonVO? lesson;
  static const String apiEndpoint =
      "http://13.125.197.66:18090/api/lesson"; // 🔥 서버 주소
  final Dio dio = Dio();

  // 더미 데이터 (서버 데이터 없을 시 사용)
  final LessonVO dummyLesson = LessonVO(
    lessonId: 0,
    userId: 101,
    lessonName: "기초 요가 스트레칭",
    lessonDesc: "기초적인 요가 동작을 통해 스트레칭 하는 법을 배워봅시다.",
    lessonCategory: 1,
    lessonSubCategory: 2,
    lessonFreeLecture: "https://youtu.be/Ei3eoqXmkjU?si=W60TzlwbXhJErL4F",
    lessonCostLecture: "",
    lessonThumbnail: "",
    lessonPrice: 15000,
    registerDate: "2024-03-10",
    isHidden: false,
    updDate: "2024-03-10",
    userName: "User #101",
    userThumbnail: "assets/images/instructor.png",
  );

  @override
  void initState() {
    super.initState();
    fetchLessonData(0); // 데이터 불러오기
  }

  // 🔥서버 데이터 호출하고, 없으면 더미 사용
  Future<void> fetchLessonData(int lessonId) async {
    final dio = Dio();
    try {
      final response = await dio.get('$apiEndpoint/$lessonId');

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          lesson = LessonVO.fromJson(response.data);
          initializeYoutubePlayer(lesson!.lessonFreeLecture);
        });
      } else {
        setState(() {
          lesson = dummyLesson;
          initializeYoutubePlayer(dummyLesson.lessonFreeLecture);
        });
      }
    } catch (e) {
      print('API 오류: $e');
      setState(() {
        lesson = dummyLesson;
        initializeYoutubePlayer(dummyLesson.lessonFreeLecture);
      });
    }
  }

  void initializeYoutubePlayer(String youtubeUrl) {
    final videoId = YoutubePlayer.convertUrlToId(youtubeUrl) ?? "";
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller),
      builder: (context, player) {
        return MainLayout(
          showPaymentButton: true,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFE6E6FA),
              automaticallyImplyLeading: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.category} / ${widget.subCategory}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.lectureTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4E342E),
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
                              backgroundImage: AssetImage(
                                'assets/images/instructor.png',
                              ),
                            ),
                            const SizedBox(width: 8), // 이 값으로 간격 조정 가능
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "강사: User #101",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "등록일: 2024-03-10",
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
                              color: Color(0xFF4E342E),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '15,000원',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4E342E),
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
                              color: Color(0xFF4E342E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                "이 강의는 기초 요가 스트레칭을 배우는 과정으로, 몸의 유연성을 기르고 건강을 유지하는 데 도움을 줍니다.",
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
