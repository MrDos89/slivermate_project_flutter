import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';

class NewClubPage extends StatefulWidget {
  const NewClubPage({super.key});

  @override
  State<NewClubPage> createState() => _NewClubPageState();
}

class _NewClubPageState extends State<NewClubPage> {
  // 선택된 모임 이름
  String clubName = '';

  // 취미/관심사 버튼 선택 (기본값 첫 번째 항목 선택)
  List<String> selectedInterests = ['뜨개질'];

  // 정기 모임 선택 체크박스 (기본값 첫 번째 항목 선택)
  String selectedMeetingFrequency = '매일';

  // 모임 가입 인원 선택 (기본값 첫 번째 항목 선택)
  String selectedCapacity = '~10명';

  // 모임 썸네일 URL
  String thumbnailURL = '';

  // 모임 소개글
  String description = '';

  // 모임 이름 글자 제한
  final int maxClubNameLength = 15;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "새 모임 만들기"),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 모임 이름 입력창
                buildClubNameInput(),

                // 취미 / 관심사 선택 버튼
                buildInterestCategorySelector(),

                // 정기 모임 선택 체크박스
                buildRegularMeetingSelector(),

                // 모임 소개글 입력창
                buildDescriptionInput(),

                // 모임 썸네일 입력창
                buildThumbnailInput(),

                // 모임 취소하기 및 모임 만들기 버튼
                buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. 모임 이름 입력창
  Widget buildClubNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "모임 이름을 만들어주세요.",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black, // 글씨 색상
          ),
        ),
        SizedBox(height: 20), // 텍스트와 입력창 사이의 틈을 만듦
        TextField(
          onChanged: (value) {
            setState(() {
              clubName = value;
            });
          },
          maxLength: maxClubNameLength,
          decoration: InputDecoration(
            hintText: "짧고 간결하게 입력해주세요.",
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ), // 힌트 텍스트 스타일
            counterText: "${clubName.length}/$maxClubNameLength",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade400, // 테두리 색상
              ),
            ),
            filled: true,
            fillColor: Colors.grey.shade100, // 배경 색상
          ),
        ),
      ],
    );
  }

  // 2. 취미 / 관심사 선택 버튼
  Widget buildInterestCategorySelector() {
    List<String> interests = [
      '뜨개질',
      '그림',
      '독서',
      '영화감상',
      '퍼즐',
      '요리',
      '통기타',
      '당구',
      '바둑',
      '등산',
      '자전거',
      '캠핑',
      '낚시',
      '러닝/마라톤',
      '수영',
      '골프',
      '테니스',
      '족구',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "취미 / 관심사",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              interests.map((interest) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedInterests.clear(); //  선택된 값이 있으면 초기화
                      selectedInterests.add(interest); //  하나만 선택 가능
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color:
                          selectedInterests.contains(interest)
                              ? Colors.black
                              : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      interest,
                      style: TextStyle(
                        color:
                            selectedInterests.contains(interest)
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  // 3. 정기 모임 선택 체크박스
  Widget buildRegularMeetingSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 모임 횟수
        Text(
          "모임 횟수",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              [
                '매일',
                '주 1회',
                '주 2~3회',
                '주 4회',
                '주 5~7회',
                '월 1회',
                '월 2~3회',
                '월 4회',
                '월 5~6회',
                '월 7~9회',
              ].map((frequency) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedMeetingFrequency == frequency) {
                      } else {
                        selectedMeetingFrequency = frequency; //  새로운 선택
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color:
                          selectedMeetingFrequency == frequency
                              ? Colors.black
                              : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      frequency,
                      style: TextStyle(
                        color:
                            selectedMeetingFrequency == frequency
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),

        SizedBox(height: 20), // 간격 조정
        // 모임 가입 인원
        Text(
          "모임 가입 인원",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              ['~10명', '~20명', '~30명', '~50명', '~100명'].map((capacity) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedCapacity == capacity) {
                      } else {
                        selectedCapacity = capacity; // 새로운 선택
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color:
                          selectedCapacity == capacity
                              ? Colors.black
                              : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      capacity,
                      style: TextStyle(
                        color:
                            selectedCapacity == capacity
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  // 4. 모임 소개글 입력창
  Widget buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "모임 소개글",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextField(
          onChanged: (value) {
            setState(() {
              description = value;
            });
          },
          decoration: InputDecoration(
            hintText: "모임에 대해 간단히 설명해주세요",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  // 5. 모임 썸네일 입력창
  Widget buildThumbnailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "모임 썸네일",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextField(
          onChanged: (value) {
            setState(() {
              thumbnailURL = value;
            });
          },
          decoration: InputDecoration(
            hintText: "썸네일 URL을 입력하세요",
            border: OutlineInputBorder(),
          ),
        ),
        // 썸네일 이미지를 화면에 표시 (이미지 URL을 입력받아 표시)
        if (thumbnailURL.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.network(thumbnailURL),
          ),
      ],
    );
  }

  // 모임 취소하기 및 모임 만들기 버튼
  Widget buildActionButtons() {
    return Column(
      children: [
        SizedBox(height: 20), // 버튼 간 간격
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // 취소 버튼 클릭 시
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('모임 가입이 취소되었습니다'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // 알림 닫기
                              },
                              child: Text('확인'),
                            ),
                          ],
                        ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // 둥근 버튼
                  ),
                ),
                child: Text(
                  '모임 취소하기',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5), // 두 버튼 사이에 5px 틈
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // 모임 만들기 버튼 클릭 시
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('모임 만들기에 성공하였습니다'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // 알림 닫기
                              },
                              child: Text('확인'),
                            ),
                          ],
                        ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // 둥근 버튼
                  ),
                ),
                child: Text(
                  '모임 만들기',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
