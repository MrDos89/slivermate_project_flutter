import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/postVo.dart';
import 'package:slivermate_project_flutter/vo/commentVo.dart';
import 'package:slivermate_project_flutter/pages/postDetailPage.dart';
import 'package:readmore/readmore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:slivermate_project_flutter/pages/newPostPage.dart';


PostVo dummyPost = PostVo(
    userThumbnail: "https://mblogthumb-phinf.pstatic.net/20160320_155/rabbitcat_14584632589491c2m0_JPEG/%BA%F1%BC%F5%C4%B3%B8%AF%C5%CD.jpg?type=w800",
    userNickname: "라이언",
    regionId: 1,
    categoryNames: 1,
    subCategory: 8,
    postNote: "오랜만에 바둑 뒀어요. 재미있네요. 함께 바둑 공부할 사람 모집합니다.",
    countLikes: 0,
    countComment: 0,
    postImage:"https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.webp",
    registerDate: DateTime.now(),
    comments: [  // 👈 댓글 추가!
      CommentVo(
        userThumbnail: "https://example.com/user1.jpg",
        userNickname: "철수",
        commentText: "저 참여할게요!",
        commentDate: DateTime.now(),
      ),
      CommentVo(
        userThumbnail: "https://example.com/user2.jpg",
        userNickname: "영희",
        commentText: "재밌겠어요!",
        commentDate: DateTime.now().subtract(Duration(minutes: 30)),
      ),
    ],
);

List<PostVo> dummyPostList = [
  PostVo(
    userThumbnail: "https://image.dongascience.com/Photo/2020/03/5bddba7b6574b95d37b6079c199d7101.jpg",
    userNickname: "라이언",
    regionId: 1,
    categoryNames: 1,
    subCategory: 8,
    postNote: "오랜만에 바둑 뒀어요. 재미있네요. 함께 바둑 공부할 사람 모집합니다. 테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트",
    countLikes: 2,
    countComment: 3,
    postImage: "",
    registerDate: DateTime.now(),
    comments: [
      CommentVo(
        userThumbnail: "",
        userNickname: "철수",
        commentText: "저도 참여할 수 있을까요?",
        commentDate: DateTime.now().subtract(Duration(minutes: 15)),
      ),
      CommentVo(
        userThumbnail: "",
        userNickname: "영희",
        commentText: "실력은 초보지만 같이해요!",
        commentDate: DateTime.now().subtract(Duration(minutes: 30)),
      ),
      CommentVo(
        userThumbnail: "",
        userNickname: "민수",
        commentText: "몇 시에 모이나요?",
        commentDate: DateTime.now().subtract(Duration(hours: 1)),
      ),
    ],
  ),
  PostVo(
    userThumbnail: "https://mblogthumb-phinf.pstatic.net/20160320_155/rabbitcat_14584632589491c2m0_JPEG/%BA%F1%BC%F5%C4%B3%B8%AF%C5%CD.jpg?type=w800",
    userNickname: "라이언",
    regionId: 1,
    categoryNames: 1,
    subCategory: 8,
    postNote: "당구 좋아하시는 분 함께 쳐요!테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트",
    countLikes: 1,
    countComment: 1,
    postImage: "https://static.cdn.kmong.com/gigs/2syJC1722251676.jpg",
    registerDate: DateTime(2025, 3, 28, 14, 32),
    comments: [
      CommentVo(
        userThumbnail: "",
        userNickname: "현수",
        commentText: "장소가 어디인가요?",
        commentDate: DateTime.now().subtract(Duration(hours: 2)),
      ),
    ],
  ),
  PostVo(
    userThumbnail: "https://mblogthumb-phinf.pstatic.net/20160320_155/rabbitcat_14584632589491c2m0_JPEG/%BA%F1%BC%F5%C4%B3%B8%AF%C5%CD.jpg?type=w800",
    userNickname: "라이언",
    regionId: 1,
    categoryNames: 1,
    subCategory: 8,
    postNote: "독서 모임 할 사람!",
    countLikes: 3,
    countComment: 2,
    postImage: "https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.webp",
    registerDate: DateTime(2025, 3, 28, 14, 30),
    comments: [
      CommentVo(
        userThumbnail: "",
        userNickname: "지수",
        commentText: "책은 정해졌나요?",
        commentDate: DateTime.now().subtract(Duration(hours: 4)),
      ),
      CommentVo(
        userThumbnail: "",
        userNickname: "수진",
        commentText: "어떤 장르인지 궁금해요!",
        commentDate: DateTime.now().subtract(Duration(hours: 3, minutes: 30)),
      ),
    ],
  ),
  PostVo(
    userThumbnail: "https://image.dongascience.com/Photo/2020/03/5bddba7b6574b95d37b6079c199d7101.jpg",
    userNickname: "라이언",
    regionId: 1,
    categoryNames: 1,
    subCategory: 8,
    postNote: "그림 그리기 좋아하시는 분들 계신가요?",
    countLikes: 0,
    countComment: 0,
    postImage: "https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.webp",
    registerDate: DateTime(2024, 11, 25, 14, 30),
    comments: [], // 댓글 없음
  ),
  PostVo(
    userThumbnail: "https://mblogthumb-phinf.pstatic.net/20160320_155/rabbitcat_14584632589491c2m0_JPEG/%BA%F1%BC%F5%C4%B3%B8%AF%C5%CD.jpg?type=w800",
    userNickname: "라이언",
    regionId: 1,
    categoryNames: 1,
    subCategory: 8,
    postNote: "오늘 영화 볼 사람?",
    countLikes: 1,
    countComment: 1,
    postImage: "https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.webp",
    registerDate: DateTime(2025, 3, 25, 14, 30),
    comments: [
      CommentVo(
        userThumbnail: "",
        userNickname: "도윤",
        commentText: "어떤 영화인가요?",
        commentDate: DateTime.now().subtract(Duration(days: 1, hours: 1)),
      ),
    ],
  ),
  PostVo(
    userThumbnail: "",
    userNickname: "민지",
    regionId: 2,
    categoryNames: 2,
    subCategory: 2,
    postNote: "자전거 라이딩 같이해요~ 주말에 한강에서 모여요!",
    countLikes: 4,
    countComment: 2,
    postImage: "https://previews.123rf.com/images/breakingdots/breakingdots2304/breakingdots230400781/202938341-%EA%B3%A0%EC%96%91%EC%9D%B4-%EA%B7%80%EC%97%AC%EC%9A%B4-%EC%BA%90%EB%A6%AD%ED%84%B0-%EB%A7%8C%ED%99%94-%EB%B2%A1%ED%84%B0-%EC%9D%BC%EB%9F%AC%EC%8A%A4%ED%8A%B8-%EB%A0%88%EC%9D%B4%EC%85%98.jpg",
    registerDate: DateTime.now().subtract(Duration(days: 2)),
    comments: [
      CommentVo(
        userThumbnail: "",
        userNickname: "태호",
        commentText: "좋아요! 몇 시에 볼까요?",
        commentDate: DateTime.now().subtract(Duration(days: 2, hours: 3)),
      ),
      CommentVo(
        userThumbnail: "",
        userNickname: "지연",
        commentText: "참여 가능한가요?",
        commentDate: DateTime.now().subtract(Duration(days: 2, hours: 2, minutes: 20)),
      ),
    ],
  ),
  PostVo(
    userThumbnail: "https://item.kakaocdn.net/do/bef59207f5155a4eddd632c9a833e80d7154249a3890514a43687a85e6b6cc82",
    userNickname: "영민",
    regionId: 3,
    categoryNames: 1,
    subCategory: 6,
    postNote: "쿠킹 클래스 회원 모집합니다. 이번엔 이탈리안 요리!",
    countLikes: 5,
    countComment: 1,
    postImage: "https://previews.123rf.com/images/breakingdots/breakingdots2304/breakingdots230400781/202938341-%EA%B3%A0%EC%96%91%EC%9D%B4-%EA%B7%80%EC%97%AC%EC%9A%B4-%EC%BA%90%EB%A6%AD%ED%84%B0-%EB%A7%8C%ED%99%94-%EB%B2%A1%ED%84%B0-%EC%9D%BC%EB%9F%AC%EC%8A%A4%ED%8A%B8-%EB%A0%88%EC%9D%B4%EC%85%98.jpg",
    registerDate: DateTime.now().subtract(Duration(days: 5)),
    comments: [
      CommentVo(
        userThumbnail: "",
        userNickname: "지혜",
        commentText: "재료 준비물이 있나요?",
        commentDate: DateTime.now().subtract(Duration(days: 5, hours: 5)),
      ),
    ],
  ),
  PostVo(
    userThumbnail: "",
    userNickname: "하늘",
    regionId: 4,
    categoryNames: 2,
    subCategory: 3,
    postNote: "캠핑 가고 싶은 사람들 모여요!",
    countLikes: 10,
    countComment: 4,
    postImage: "https://previews.123rf.com/images/breakingdots/breakingdots2304/breakingdots230400781/202938341-%EA%B3%A0%EC%96%91%EC%9D%B4-%EA%B7%80%EC%97%AC%EC%9A%B4-%EC%BA%90%EB%A6%AD%ED%84%B0-%EB%A7%8C%ED%99%94-%EB%B2%A1%ED%84%B0-%EC%9D%BC%EB%9F%AC%EC%8A%A4%ED%8A%B8-%EB%A0%88%EC%9D%B4%EC%85%98.jpg",
    registerDate: DateTime.now().subtract(Duration(days: 10)),
    comments: [
      CommentVo(
        userThumbnail: "",
        userNickname: "소연",
        commentText: "장소는 정해졌나요?",
        commentDate: DateTime.now().subtract(Duration(days: 10, hours: 4)),
      ),
      CommentVo(
        userThumbnail: "",
        userNickname: "우진",
        commentText: "텐트랑 장비는 각자 준비인가요?",
        commentDate: DateTime.now().subtract(Duration(days: 10, hours: 3)),
      ),
      CommentVo(
        userThumbnail: "",
        userNickname: "민혁",
        commentText: "불멍하고 싶네요!",
        commentDate: DateTime.now().subtract(Duration(days: 10, hours: 2, minutes: 15)),
      ),
      CommentVo(
        userThumbnail: "https://item.kakaocdn.net/do/bef59207f5155a4eddd632c9a833e80d7154249a3890514a43687a85e6b6cc82",
        userNickname: "승아",
        commentText: "다음엔 꼭 갈게요~",
        commentDate: DateTime.now().subtract(Duration(days: 9)),
      ),
    ],
  ),
  PostVo(
    userThumbnail: "",
    userNickname: "예린",
    regionId: 5,
    categoryNames: 2,
    subCategory: 1,
    postNote: "등산 동호회에서 이번 주 토요일 산행갑니다.",
    countLikes: 7,
    countComment: 2,
    postImage: "https://previews.123rf.com/images/breakingdots/breakingdots2304/breakingdots230400781/202938341-%EA%B3%A0%EC%96%91%EC%9D%B4-%EA%B7%80%EC%97%AC%EC%9A%B4-%EC%BA%90%EB%A6%AD%ED%84%B0-%EB%A7%8C%ED%99%94-%EB%B2%A1%ED%84%B0-%EC%9D%BC%EB%9F%AC%EC%8A%A4%ED%8A%B8-%EB%A0%88%EC%9D%B4%EC%85%98.jpg",
    registerDate: DateTime.now().subtract(Duration(days: 3)),
    comments: [
      CommentVo(
        userThumbnail: "",
        userNickname: "수아",
        commentText: "초보도 갈 수 있나요?",
        commentDate: DateTime.now().subtract(Duration(days: 3, hours: 1)),
      ),
      CommentVo(
        userThumbnail: "",
        userNickname: "건우",
        commentText: "저도 신청할게요!",
        commentDate: DateTime.now().subtract(Duration(days: 2, hours: 22)),
      ),
    ],
  ),
  PostVo(
    userThumbnail: "",
    userNickname: "준서",
    regionId: 6,
    categoryNames: 1,
    subCategory: 7,
    postNote: "통기타 초보 모임! 같이 배워봐요.",
    countLikes: 3,
    countComment: 3,
    postImage: "https://previews.123rf.com/images/breakingdots/breakingdots2304/breakingdots230400781/202938341-%EA%B3%A0%EC%96%91%EC%9D%B4-%EA%B7%80%EC%97%AC%EC%9A%B4-%EC%BA%90%EB%A6%AD%ED%84%B0-%EB%A7%8C%ED%99%94-%EB%B2%A1%ED%84%B0-%EC%9D%BC%EB%9F%AC%EC%8A%A4%ED%8A%B8-%EB%A0%88%EC%9D%B4%EC%85%98.jpg",
    registerDate: DateTime.now().subtract(Duration(days: 7)),
    comments: [
      CommentVo(
        userThumbnail: "",
        userNickname: "지훈",
        commentText: "기타가 없는데 참여 가능할까요?",
        commentDate: DateTime.now().subtract(Duration(days: 7, hours: 4)),
      ),
      CommentVo(
        userThumbnail: "",
        userNickname: "하영",
        commentText: "장소는 어디인가요?",
        commentDate: DateTime.now().subtract(Duration(days: 7, hours: 2, minutes: 45)),
      ),
      CommentVo(
        userThumbnail: "",
        userNickname: "세훈",
        commentText: "악보는 미리 받아볼 수 있나요?",
        commentDate: DateTime.now().subtract(Duration(days: 6, hours: 20)),
      ),
    ],
  ),
  PostVo(
    userThumbnail: "",
    userNickname: "하람",
    regionId: 1, // 서울특별시
    categoryNames: 1, // 실내
    subCategory: 0, // 일상
    postNote: "요즘 날씨 너무 좋아요~ 산책하면서 봄바람 느끼는 중 🌸",
    countLikes: 5,
    countComment: 2,
    postImage: "https://previews.123rf.com/images/breakingdots/breakingdots2304/breakingdots230400781/202938341-%EA%B3%A0%EC%96%91%EC%9D%B4-%EA%B7%80%EC%97%AC%EC%9A%B4-%EC%BA%90%EB%A6%AD%ED%84%B0-%EB%A7%8C%ED%99%94-%EB%B2%A1%ED%84%B0-%EC%9D%BC%EB%9F%AC%EC%8A%A4%ED%8A%B8-%EB%A0%88%EC%9D%B4%EC%85%98.jpg",
    registerDate: DateTime.now().subtract(Duration(hours: 5)),
    comments: [
      CommentVo(
        userThumbnail: "",
        userNickname: "주연",
        commentText: "와 사진 너무 예뻐요!",
        commentDate: DateTime.now().subtract(Duration(hours: 4, minutes: 30)),
      ),
      CommentVo(
        userThumbnail: "",
        userNickname: "진우",
        commentText: "산책 코스 어디에요?",
        commentDate: DateTime.now().subtract(Duration(hours: 3, minutes: 10)),
      ),
    ],
  ),
  PostVo(
    userThumbnail: "",
    userNickname: "다영",
    regionId: 3, // 대전광역시
    categoryNames: 1, // 실내
    subCategory: 0, // 일상
    postNote: "집에서 커피 내려 마시면서 좋아하는 책 읽는 중입니다 ☕📖",
    countLikes: 3,
    countComment: 1,
    postImage: "https://previews.123rf.com/images/breakingdots/breakingdots2304/breakingdots230400781/202938341-%EA%B3%A0%EC%96%91%EC%9D%B4-%EA%B7%80%EC%97%AC%EC%9A%B4-%EC%BA%90%EB%A6%AD%ED%84%B0-%EB%A7%8C%ED%99%94-%EB%B2%A1%ED%84%B0-%EC%9D%BC%EB%9F%AC%EC%8A%A4%ED%8A%B8-%EB%A0%88%EC%9D%B4%EC%85%98.jpg",
    registerDate: DateTime.now().subtract(Duration(days: 1, hours: 2)),
    comments: [
      CommentVo(
        userThumbnail: "",
        userNickname: "성우",
        commentText: "힐링 그 자체네요!",
        commentDate: DateTime.now().subtract(Duration(days: 1, hours: 1, minutes: 20)),
      ),
    ],
  ),
];

//  카테고리 ID를 문자열로 변환
const Map<int, String> categoryNames = {1: "실내", 2: "실외"};

//  취미 ID를 문자열로 변환 (카테고리별로 따로 저장)
const Map<int, String> indoorHobbies = {
  -1: "전체",
  0: "일상",
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

Map<int, String> regionMap = {
  1: "서울특별시",
  2: "부산광역시",
  3: "대구광역시",
  4: "인천광역시",
  5: "광주광역시",
  6: "대전광역시",
  7: "울산광역시",
  8: "세종특별자치시",
  9: "경기도",
  10: "강원도",
  11: "충청북도",
  12: "충청남도",
  13: "전라북도",
  14: "전라남도",
  15: "경상북도",
  16: "경상남도",
  17: "제주특별자치도",
  18: "울릉도",
};

class PostPage extends StatefulWidget {
  final PostVo? dummyPost;

  const PostPage({super.key, required this.dummyPost});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int? _selectedRegionId; // 지역
  Set<int> _selectedSubCategoryIds = {};

  Future<void> _refreshDummyPostList() async {
    await Future.delayed(const Duration(seconds: 1)); // 리프레시 느낌 나게 딜레이
    setState(() {
      dummyPostList = List.from(dummyPostList); // 새 객체로 복사
    });
  }

  void _showCommentModal(BuildContext context, PostVo post) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: MediaQuery
                  .of(context)
                  .viewInsets,
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('댓글', style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),

                    Expanded(
                      child: post.comments.isEmpty
                          ? const Center(child: Text("아직 등록된 댓글이 없습니다."))
                          : ListView.builder(
                        itemCount: post.comments.length,
                        itemBuilder: (context, index) {
                          final comment = post.comments[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                comment.userThumbnail
                                    .trim()
                                    .isEmpty ? defaultUserThumbnail : comment
                                    .userThumbnail,
                              )
                              ,
                            ),
                            title: Text(comment.userNickname,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(comment.commentText),
                            trailing: Text(
                              "${comment.commentDate.hour}:${comment.commentDate
                                  .minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ),

                    // 댓글 입력 필드
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: '댓글을 입력하세요',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            if (commentController.text
                                .trim()
                                .isNotEmpty) {
                              setModalState(() {
                                post.comments.add(CommentVo(
                                  userThumbnail: "", // 현재 사용자 프로필 이미지
                                  userNickname: "현재 사용자", // 현재 사용자 닉네임
                                  commentText: commentController.text.trim(),
                                  commentDate: DateTime.now(),
                                ));
                                commentController.clear();
                              });

                              setState(() {}); // 메인 화면 업데이트
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<PostVo> filteredList = dummyPostList.where((post) {
      bool regionMatch = _selectedRegionId == null || post.regionId == _selectedRegionId;

      bool subCategoryMatch = _selectedSubCategoryIds.isEmpty ||
          _selectedSubCategoryIds.contains(post.subCategory);

      return regionMatch && subCategoryMatch;
    }).toList();

    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "피드 페이지"),
        ),
        body: Container(
          color: const Color(0xFFF5F5F5),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 지역 드롭다운
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: RegionDropdown(
                    value: _selectedRegionId,
                    onChanged: (value) {
                      setState(() {
                        _selectedRegionId = value; // null 허용됨
                      });
                    },
                  )
                ),
                // const SizedBox(height: ),

                // 카테고리 선택 (Chip 형태)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '카테고리',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 35, // 칩 높이 제한
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal, // 가로 슬라이드 활성화
                            child: Row(
                              children: {
                                ...indoorHobbies.entries,
                                ...outdoorHobbies.entries,
                              }.map((e) {
                                final bool isSelected = _selectedSubCategoryIds
                                    .contains(e.key);
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: FilterChip(
                                    label: Text(e.value),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setState(() {
                                        if (e.key == -1) {
                                          // '전체' 선택 시 모든 선택 초기화
                                          if (selected) {
                                            _selectedSubCategoryIds.clear();
                                          }
                                        } else {
                                          if (selected) {
                                            _selectedSubCategoryIds.add(e.key);
                                            _selectedSubCategoryIds.remove(-1); // 다른 항목 선택 시 '전체' 제거
                                          } else {
                                            _selectedSubCategoryIds.remove(e.key);
                                          }
                                        }
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                child: postContainer(context, postList: filteredList, onRefresh: _refreshDummyPostList),
              )

              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // 버튼 클릭 시 NewPostPage로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NewPostPage()),
            );
          },
          backgroundColor: Colors.green,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
      ),
    );
  }

  Widget postContainer(BuildContext context, {required List<PostVo> postList, required Future<void> Function() onRefresh}) {
    if (postList.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inbox, size: 60, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                "해당되는 피드가 없습니다.",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 6),
              Text(
                "첫 번째 피드를 남겨주세요.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.71,
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 40),
                ...postList.map((dummyPost) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailPage(Post: dummyPost),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage(
                                      dummyPost.userThumbnail.trim().isEmpty
                                          ? defaultUserThumbnail
                                          : dummyPost.userThumbnail,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dummyPost.userNickname,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${regionMap[dummyPost.regionId]!} · ${dummyPost.categoryNames == 1 ? indoorHobbies[dummyPost.subCategory] : outdoorHobbies[dummyPost.subCategory]}",
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (dummyPost.postImage != null &&
                                  dummyPost.postImage!.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    dummyPost.postImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 180,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        alignment: Alignment.center,
                                        height: 180,
                                        child: const CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        alignment: Alignment.center,
                                        height: 180,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image, color: Colors.grey),
                                      );
                                    },
                                  ),
                                ),
                              const SizedBox(height: 8),
                              ReadMoreText(
                                dummyPost.postNote,
                                trimLines: 2,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: ' ...더보기',
                                trimExpandedText: ' 접기',
                                style: const TextStyle(fontSize: 16),
                                moreStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                                lessStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      LikeHeart(initialLikes: dummyPost.countLikes),
                                      const SizedBox(width: 16),
                                      GestureDetector(
                                        onTap: () => _showCommentModal(context, dummyPost),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.comment_outlined,
                                                size: 18, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text('${dummyPost.comments.length}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    getTimeAgo(dummyPost.registerDate),
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        )
      ],
    );
  }

}


// "준비중" 팝업 다이얼로그 함수
// void _showComingSoonDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder:
//         (context) => AlertDialog(
//           title: const Text("준비중"),
//           content: const Text("해당 기능은 아직 준비중입니다."),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("확인"),
//             ),
//           ],
//         ),
//   );
// }

class LikeHeart extends StatefulWidget {
  final int initialLikes;

  const LikeHeart({super.key, required this.initialLikes});

  @override
  State<LikeHeart> createState() => _LikeHeartState();
}

class _LikeHeartState extends State<LikeHeart> with SingleTickerProviderStateMixin {
  late int _likes;
  bool _isLiked = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _likes = widget.initialLikes;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapLike() {
    setState(() {
      if (_isLiked) {
        _likes--;
      } else {
        _likes++;
        _controller.forward().then((_) => _controller.reverse());
      }
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTapLike,
      child: Row(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.red : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 4),
          Text('$_likes'),
        ],
      ),
    );
  }
}

// final TextEditingController _commentController = TextEditingController();
// List<String> _comments = [];

String getTimeAgo(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  final minutes = diff.inMinutes;
  final hours = diff.inHours;
  final days = diff.inDays;
  final months = (days / 30).floor();
  final years = (days / 365).floor();

  if (minutes < 60) return '$minutes분 전';
  if (hours < 24) return '$hours시간 전';
  if (days < 30) return '$days일 전';
  if (days < 365) return '$months달 전';
  return '$years년 전';
}

final postUserThumbnail = (dummyPost.userThumbnail.trim().isEmpty)
    ? defaultUserThumbnail
    : dummyPost.userThumbnail;


// 유저 썸네일 기본 이미지, 설정 안했을 경우 나올 이미지 설정
const String defaultUserThumbnail = "https://cdn.pixabay.com/photo/2023/09/13/07/29/ghost-8250317_640.png";

// 지역 선택 위젯
class RegionDropdown extends StatelessWidget {
  final int? value;
  final void Function(int?) onChanged;

  const RegionDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<int?>(
      isExpanded: true,
      value: value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        labelText: '지역 선택',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
      items: [
        const DropdownMenuItem<int?>(
          value: null, // null 값 허용
          child: Text("전체 지역"),
        ),
        ...regionMap.entries.map(
              (entry) => DropdownMenuItem<int?>(
            value: entry.key,
            child: Text(entry.value),
          ),
        ),
      ],
      onChanged: onChanged,
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
