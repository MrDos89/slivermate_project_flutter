import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: false, // 🔥 자동 재생 OFF
        mute: false, // 🔥 음소거 해제
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // 🔥 컨트롤러 정리
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "강사: User #101",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(
                              "등록일: 2024-03-10",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
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
