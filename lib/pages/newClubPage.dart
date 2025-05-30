import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/service/clubApiService.dart';
import 'package:provider/provider.dart';
import 'package:slivermate_project_flutter/components/userProvider.dart';
import 'package:slivermate_project_flutter/vo/clubVo.dart';
import 'package:slivermate_project_flutter/components/uploadClubThumbnail.dart';

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

                SizedBox(height: 20), // 간격 추가

                Divider(), // 구분선 추가
                // 취미 / 관심사 선택 버튼
                buildInterestCategorySelector(),

                SizedBox(height: 30), // 간격 추가

                Divider(), // 구분선 추가
                // 정기 모임 선택 체크박스
                buildRegularMeetingSelector(),

                SizedBox(height: 30), // 간격 추가

                Divider(), // 구분선 추가
                // 모임 가입 인원 선택
                buildCapacitySelector(),

                SizedBox(height: 30), // 간격 추가

                Divider(), // 구분선 추가
                // 모임 소개글 입력창
                buildDescriptionInput(),

                SizedBox(height: 30), // 간격 추가

                Divider(), // 구분선 추가
                // 모임 썸네일 입력창
                buildThumbnailInput(),

                SizedBox(height: 30),

                Divider(),

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
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 20), // 텍스트와 입력창 사이의 틈
        TextField(
          onChanged: (value) {
            setState(() {
              clubName = value;
            });
          },
          maxLength: maxClubNameLength,
          decoration: InputDecoration(
            hintText: "짧고 간결하게 입력해주세요.",
            hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
            counterText: "${clubName.length}/$maxClubNameLength",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            filled: true,
            fillColor: Colors.white,
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
        SizedBox(height: 10), // 텍스트와 입력창 사이의 틈
        Text(
          "취미 / 관심사",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20), // 텍스트와 입력창 사이의 틈
        Wrap(
          spacing: 15,
          runSpacing: 25,
          children:
          interests.map((interest) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedInterests.clear(); // 선택된 값이 있으면 초기화
                  selectedInterests.add(interest); // 하나만 선택 가능
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color:
                  selectedInterests.contains(interest)
                      ? Colors.black
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5),
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
        SizedBox(height: 10), // 텍스트와 입력창 사이의 틈
        Text(
          "모임 횟수",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20), // 텍스트와 입력창 사이의 틈
        Wrap(
          spacing: 15,
          runSpacing: 25,
          children:
          [
            '매일',
            '주 1회',
            '주 2~3회',
            '주 5회이상',
            '월 1회',
            '월 2~3회',
            '매월 주말마다',
            '매월 토요일마다',
            '매월 일요일마다',
          ].map((frequency) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedMeetingFrequency = frequency; // 선택
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color:
                  selectedMeetingFrequency == frequency
                      ? Colors.black
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5),
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
      ],
    );
  }

  // 4. 모임 가입 인원 선택
  Widget buildCapacitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10), // 텍스트와 입력창 사이의 틈
        Text(
          "모임 가입 인원",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20), // 텍스트와 입력창 사이의 틈
        Wrap(
          spacing: 50,
          runSpacing: 25,
          children:
          ['~10명', '~20명', '~30명', '~50명', '~100명'].map((capacity) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCapacity = capacity; // 선택
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color:
                  selectedCapacity == capacity
                      ? Colors.black
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5),
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

  // 5. 모임 소개글 입력창
  Widget buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10), // 텍스트와 입력창 사이의 틈
        Text(
          "모임 소개글",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20), // 텍스트와 입력창 사이의 틈
        TextField(
          onChanged: (value) {
            setState(() {
              description = value;
            });
          },
          decoration: InputDecoration(
            hintText: "모임에 대해 간단히 설명해주세요",
            hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  // 6. 모임 썸네일 입력창
  Widget buildThumbnailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "모임 썸네일",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        UploadClubThumbnail(
          onUpload: (url) {
            setState(() {
              thumbnailURL = url;
            });
          },
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
                  showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          title: Text('모임 가입이 취소되었습니다'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '모임 취소하기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final userProvider = Provider.of<UserProvider>(context, listen: false);
                    final user = userProvider.user;

                    if (user == null) {
                      // 로그인 정보가 없을 때 예외 처리
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('로그인이 필요합니다'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('확인'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    final newClub = ClubVo(
                      clubId: 0,
                      clubName: clubName,
                      clubUserId: user.uid,
                      clubUserNickname: user.nickname,
                      clubCategoryId: _getMainCategoryId(
                          selectedInterests.first),
                      clubSubCategoryId: _getSubCategoryId(
                          selectedInterests.first),
                      clubThumbnail: thumbnailURL,
                      clubMovie: '',
                      clubDesc: description,
                      clubMemberNumber: 1,
                      clubMemberMax: _getMaxCapacity(selectedCapacity),
                      clubReportCnt: 0,
                      clubRegisterDate: DateTime.now(),
                      isDeleted: false,
                      updDate: DateTime.now(),
                    );

                    await createClub(newClub); // POST 요청

                    showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            title: Text('모임 만들기에 성공하였습니다'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // 다이얼로그 닫기
                                  Navigator.pop(context); // 페이지 닫기
                                },
                                child: Text('확인'),
                              ),
                            ],
                          ),
                    );
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            title: Text('모임 만들기 실패'),
                            content: Text('$e'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('닫기'),
                              ),
                            ],
                          ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '모임 만들기',
                  style: TextStyle(
                    fontSize: 20,
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

int _getMainCategoryId(String hobby) {
  const indoor = ['뜨개질', '그림', '독서', '영화감상', '퍼즐', '요리', '통기타', '당구', '바둑'];
  return indoor.contains(hobby) ? 1 : 2;
}

int _getSubCategoryId(String hobby) {
  final indoor = {
    1: "뜨개질", 2: "그림", 3: "독서", 4: "영화감상", 5: "퍼즐",
    6: "요리", 7: "통기타", 8: "당구", 9: "바둑",
  };
  final outdoor = {
    1: "등산", 2: "자전거", 3: "캠핑", 4: "낚시", 5: "러닝/마라톤",
    6: "수영", 7: "골프", 8: "테니스", 9: "족구",
  };
  final all = {...indoor, ...outdoor};
  return all.entries.firstWhere((e) => e.value == hobby, orElse: () => MapEntry(0, '기타')).key;
}

int _getMaxCapacity(String label) {
  switch (label) {
    case '~10명': return 10;
    case '~20명': return 20;
    case '~30명': return 30;
    case '~50명': return 50;
    case '~100명': return 100;
    default: return 10;
  }
}

