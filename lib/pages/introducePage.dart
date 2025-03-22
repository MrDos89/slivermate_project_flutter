import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slivermate_project_flutter/vo/lessonVo.dart';
import 'package:dio/dio.dart';

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
  bool hasPurchased = false;

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

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: '', // 기본값 (오류 방지)
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
    fetchLessonData(); //  데이터 가져오기
    print(
      " IntroducePage initState() 실행됨. dummyUser: ${widget.dummyUser?.userName}, ${widget.dummyUser?.email}",
    );
  }

  // [yj] lessonCategory와 lessonSubCategory가 설정된 후 API 호출
  void updateCategory(int category, int subCategory) {
    setState(() {
      widget.lessonCategory = category;
      widget.lessonSubCategory = subCategory;
    });

    print(
      " [카테고리 업데이트] lessonCategory: ${widget.lessonCategory}, lessonSubCategory: ${widget.lessonSubCategory}",
    );

    // [yj] 값이 설정된 후 API 호출
    fetchLessonData();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fetchLessonData(0); // 데이터 불러오기
  // }

  // [yj] API 데이터 가져오기 및 결제 정보 확인해서 강의 로드
  Future<void> fetchLessonData() async {
    try {
      final fetchedLesson = await LessonService.fetchLessonData(
        widget.lessonCategory,
        widget.lessonSubCategory,
      );

      if (fetchedLesson == null) {
        print(" 강의 데이터를 가져오지 못함.");
        return;
      }

      // [yj] 강의 정보가 제대로 들어왔는지 확인
      print(" 불러온 강의 정보: ${fetchedLesson.lessonName}");
      print("   🔹 무료 강의 URL: ${fetchedLesson.lessonFreeLecture}");
      print("   🔹 유료 강의 URL: ${fetchedLesson.lessonCostLecture}");

      final Dio dio = Dio();
      final purchaseResponse = await dio.get(
        'http://13.125.197.66:18090/api/purchase/u/${widget.dummyUser!.uid}',
        options: Options(validateStatus: (status) => true),
      );

      // bool hasPurchased = false;

      if (purchaseResponse.statusCode == 200) {
        final purchaseData = purchaseResponse.data;

        if (purchaseData is List && purchaseData.isNotEmpty) {
          widget.hasPurchased = purchaseData.any(
            (item) => item['lesson_id'] == fetchedLesson.lessonId,
          );
        }
      } else {
        print(" 결제 정보 로딩 실패: ${purchaseResponse.statusCode}");
        return;
      }

      //  [2] 결제 여부 확인
      print(" 결제 여부(hasPurchased): ${widget.hasPurchased}");

      if (widget.hasPurchased) {
        await dio.patch(
          'http://13.125.197.66:18090/api/purchase/${fetchedLesson.lessonId}/${widget.dummyUser!.uid}',
        );
      }

      //  [yj] 영상 URL 두 개를 다 관리하고, 선택적으로 제공
      String freeVideoUrl = fetchedLesson.lessonFreeLecture;
      String costVideoUrl = fetchedLesson.lessonCostLecture;

      // 유료 결제 여부에 따라 URL 선택
      String videoUrl =
          widget.hasPurchased && costVideoUrl.isNotEmpty
              ? costVideoUrl
              : freeVideoUrl;

      // [yj] 최종 선택된 영상 확인
      print(" 최종 선택된 영상 URL: $videoUrl");

      setState(() {
        lesson = fetchedLesson;
        if (videoUrl.isNotEmpty) {
          initializeYoutubePlayer(videoUrl);
          print(widget.hasPurchased ? " 유료 강의를 로드합니다." : " 무료 강의를 로드합니다.");
        } else {
          print(" 영상 URL이 없습니다!");
        }
      });
    } catch (e) {
      print(" API 호출 중 에러 발생: $e");
    }
  }

  void initializeYoutubePlayer(String youtubeUrl) {
    final videoId = YoutubePlayer.convertUrlToId(youtubeUrl) ?? "";
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
    setState(() {}); // UI 갱신 추가
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
      "[IntroducePage]  dummyUser 값: ${widget.dummyUser?.userName}, ${widget.dummyUser?.email}",
    );

    if (widget.dummyUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // 데이터 로딩 중 표시
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
              backgroundColor: const Color(
                0xFF044E00,
              ).withOpacity(0.5), // 실외 (연녹색)
              automaticallyImplyLeading: false,
              title:
                  lesson == null
                      ? const Text("강의 로딩 중...") // lesson이 null이면 기본 텍스트 표시
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
                              fontFamily: 'cts',
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
                        // 이미지를 텍스트와 묶어주는 Row
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                lesson!.userThumbnail,
                              ),
                            ),
                            const SizedBox(width: 8), // 이 값으로 간격 조정 가능
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lesson!.userName,
                                  style: TextStyle(
                                    fontFamily: 'MaruBuri',
                                    fontSize: 16,
                                    // fontWeight: FontWeight.w500,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  lesson!.getFormattedDate(), // 변환된 날짜 표시
                                  style: TextStyle(
                                    fontFamily: 'MaruBuri',
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

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
                                fontFamily: 'MaruBuri',
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
                              fontFamily: 'cts',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF077A00),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              child:
                                  widget.hasPurchased
                                      ? Text.rich(
                                        TextSpan(
                                          text: lesson!.lessonCostDesc
                                              .replaceAll(
                                                r'\n',
                                                '\n',
                                              ), // 서버에서 받은 String
                                          style: TextStyle(
                                            fontFamily: 'cts',
                                            fontSize: 18,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        textAlign: TextAlign.left,
                                      )
                                      : Text.rich(
                                        TextSpan(
                                          text: lesson!.lessonDesc.replaceAll(
                                            r'\n',
                                            '\n',
                                          ), // 서버에서 받은 String
                                          style: TextStyle(
                                            fontFamily: 'cts',
                                            fontSize: 18,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        textAlign: TextAlign.left,
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

  //  아래쪽에만 그림자 적용하는 BoxDecoration
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
