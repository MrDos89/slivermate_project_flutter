import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IntroducePage extends StatefulWidget {
  final String category;
  final String subCategory;
  final String lectureTitle;

  const IntroducePage({
    super.key,
    this.category = "실내",
    this.subCategory = "요가",
    this.lectureTitle = "기초 요가 스트레칭",
  });

  @override
  _IntroducePageState createState() => _IntroducePageState();
}

class _IntroducePageState extends State<IntroducePage> {
  String? lectureDescription; // 강의 설명
  int? lecturePrice; // 강의 금액
  int? userId; // 강의 올린 사람 ID
  DateTime? registerDate; // 강의 등록 시간
  bool isLoading = true; // 로딩 상태

  @override
  void initState() {
    super.initState();
    _fetchLectureData(); // 강의 데이터 불러오기
  }

  // 📌 서버에서 강의 데이터 가져오는 함수 (예제)
  Future<void> _fetchLectureData() async {
    await Future.delayed(const Duration(seconds: 2)); // 서버 요청 시뮬레이션 (2초 딜레이)
    setState(() {
      lectureDescription =
          "이 강의는 기초 요가 스트레칭을 배우는 과정으로, 몸의 유연성을 기르고 건강을 유지하는 데 도움을 줍니다.";
      lecturePrice = 15000; // 예제 데이터 (서버에서 받아올 값)
      userId = 101; // 강의 등록한 사용자 ID (예제)
      registerDate = DateTime.parse("2024-03-10"); // 강의 등록일 (예제)
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      showPaymentButton: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFE6E6FA),
          leading: null, // 뒤로가기 버튼 지우기
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.category} / ${widget.subCategory}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.lectureTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📌 강의 영상 자리 (임시)
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Text(
                '📌 강의 영상 자리',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),

            // 📌 강사 정보 & 등록일 & 강의 금액
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 👤 등록자 정보 (왼쪽 정렬)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "강사: User #$userId",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "등록일: ${registerDate != null ? registerDate!.toString().split(" ")[0] : "알 수 없음"}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          // 강의 가격 (오른쪽 정렬)
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.wonSign,
                                color: Colors.deepPurple,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${lecturePrice != null ? '${lecturePrice!.toString()}원' : '무료 강의'}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
            ),

            // 📌 강의 설명
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '📖 강의 설명',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                child: Text(
                                  lectureDescription ?? '강의 설명을 불러오지 못했습니다.',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
