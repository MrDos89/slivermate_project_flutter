import 'package:flutter/material.dart';

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
  int? lecturePrice; // 강의 금액 (서버에서 불러올 예정)
  bool isLoading = true; // 로딩 상태

  @override
  void initState() {
    super.initState();
    _fetchLectureData(); // 강의 데이터 불러오기
  }

  // 📌 나중에 서버 연결 시, API 호출 부분
  Future<void> _fetchLectureData() async {
    await Future.delayed(const Duration(seconds: 2)); // 서버 요청 시뮬레이션 (2초 딜레이)
    setState(() {
      lectureDescription =
          "이 강의는 기초 요가 스트레칭을 배우는 과정으로, 몸의 유연성을 기르고 건강을 유지하는 데 도움을 줍니다.";
      lecturePrice = 15000; // 예제 데이터 (서버에서 받아올 값)
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE6E6FA), // 연보라색 적용 (라벤더)
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.category} / ${widget.subCategory}', // 대분류 / 소분류
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.lectureTitle, // 강의 제목
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 강의 영상 자리 (현재는 빈 박스)
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 3, // 화면의 1/3 크기
            color: Colors.grey[300], // 임시 배경색
            alignment: Alignment.center,
            child: Text(
              '📌 강의 영상 자리',
              style: TextStyle(
                fontSize: 22, //
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          //  강의 금액 (우측 정렬)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                isLoading
                    ? const Center(
                      child: CircularProgressIndicator(),
                    ) // 로딩 중이면 인디케이터 표시
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.end, // 우측 정렬
                      children: [
                        const Icon(
                          Icons.price_check,
                          color: Colors.deepPurple,
                          size: 30,
                        ),
                        const SizedBox(width: 8), // 아이콘과 텍스트 간격 조정
                        Text(
                          '${lecturePrice != null ? '${lecturePrice!.toString()}원' : '무료 강의'}',
                          style: const TextStyle(
                            fontSize: 22, // 🔺 기존 18 → 22으로 키움
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple, // 동일한 색상 적용
                          ),
                        ),
                      ],
                    ),
          ),

          // 📌 강의 설명 (컨테이너 안에 배치)
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
                      color: Colors.black26, // 기존보다 더 자연스러운 그림자
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child:
                    isLoading
                        ? const Center(
                          child: CircularProgressIndicator(),
                        ) // 로딩 중이면 인디케이터 표시
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 📌 강의 설명 제목 추가
                            Text(
                              '📖 강의 설명',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple, // 연보라색 계열 적용
                              ),
                            ),
                            const SizedBox(height: 10), // 설명과 간격 추가
                            SingleChildScrollView(
                              child: Text(
                                lectureDescription ??
                                    '강의 설명을 불러오지 못했습니다.', // 설명이 없을 경우 대비
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87, // 대비가 높은 검은색으로 설정
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
    );
  }
}
