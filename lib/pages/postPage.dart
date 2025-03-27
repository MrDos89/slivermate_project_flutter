import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/postVo.dart';


PostVo dummyPost = PostVo(
    userThumbnail: "https://mblogthumb-phinf.pstatic.net/20160320_155/rabbitcat_14584632589491c2m0_JPEG/%BA%F1%BC%F5%C4%B3%B8%AF%C5%CD.jpg?type=w800",
    userNickname: "라이언",
    regionId: 1,
    categoryNames: 1,
    subCategory: 8,
    postNote: "오랜만에 바둑 뒀어요. 재미있네요. 함께 바둑 공부할 사람 모집합니다.",
    countLikes: 0,
    countComment: 0,
    postImage:"https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.webp"
);

List<PostVo> dummyPostList = [
  PostVo(
      userThumbnail: "https://image.dongascience.com/Photo/2020/03/5bddba7b6574b95d37b6079c199d7101.jpg",
      userNickname: "라이언",
      regionId: 1,
      categoryNames: 1,
      subCategory: 8,
      postNote: "오랜만에 바둑 뒀어요. 재미있네요. 함께 바둑 공부할 사람 모집합니다.",
      countLikes: 0,
      countComment: 0,
      postImage:"https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.webp"
  ),
  PostVo(
      userThumbnail: "https://mblogthumb-phinf.pstatic.net/20160320_155/rabbitcat_14584632589491c2m0_JPEG/%BA%F1%BC%F5%C4%B3%B8%AF%C5%CD.jpg?type=w800",
      userNickname: "라이언",
      regionId: 1,
      categoryNames: 1,
      subCategory: 8,
      postNote: "오랜만에 바둑 뒀어요. 재미있네요. 함께 바둑 공부할 사람 모집합니다.",
      countLikes: 0,
      countComment: 0,
      postImage:"https://static.cdn.kmong.com/gigs/2syJC1722251676.jpg"
  ),
  PostVo(
      userThumbnail: "https://mblogthumb-phinf.pstatic.net/20160320_155/rabbitcat_14584632589491c2m0_JPEG/%BA%F1%BC%F5%C4%B3%B8%AF%C5%CD.jpg?type=w800",
      userNickname: "라이언",
      regionId: 1,
      categoryNames: 1,
      subCategory: 8,
      postNote: "오랜만에 바둑 뒀어요. 재미있네요. 함께 바둑 공부할 사람 모집합니다.",
      countLikes: 0,
      countComment: 0,
      postImage:"https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.webp"
  ),
  PostVo(
      userThumbnail: "https://image.dongascience.com/Photo/2020/03/5bddba7b6574b95d37b6079c199d7101.jpg",
      userNickname: "라이언",
      regionId: 1,
      categoryNames: 1,
      subCategory: 8,
      postNote: "오랜만에 바둑 뒀어요. 재미있네요. 함께 바둑 공부할 사람 모집합니다.",
      countLikes: 0,
      countComment: 0,
      postImage:"https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.webp"
  ),
  PostVo(
      userThumbnail: "https://mblogthumb-phinf.pstatic.net/20160320_155/rabbitcat_14584632589491c2m0_JPEG/%BA%F1%BC%F5%C4%B3%B8%AF%C5%CD.jpg?type=w800",
      userNickname: "라이언",
      regionId: 1,
      categoryNames: 1,
      subCategory: 8,
      postNote: "오랜만에 바둑 뒀어요. 재미있네요. 함께 바둑 공부할 사람 모집합니다.",
      countLikes: 0,
      countComment: 0,
      postImage:"https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.webp"
  ),
  PostVo(
      userThumbnail: "https://mblogthumb-phinf.pstatic.net/20160320_155/rabbitcat_14584632589491c2m0_JPEG/%BA%F1%BC%F5%C4%B3%B8%AF%C5%CD.jpg?type=w800",
      userNickname: "라이언",
      regionId: 1,
      categoryNames: 1,
      subCategory: 8,
      postNote: "오랜만에 바둑 뒀어요. 재미있네요. 함께 바둑 공부할 사람 모집합니다.",
      countLikes: 0,
      countComment: 0,
      postImage:"https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.webp"
  ),
  PostVo(
      userThumbnail: "https://mblogthumb-phinf.pstatic.net/20160320_155/rabbitcat_14584632589491c2m0_JPEG/%BA%F1%BC%F5%C4%B3%B8%AF%C5%CD.jpg?type=w800",
      userNickname: "라이언",
      regionId: 1,
      categoryNames: 1,
      subCategory: 8,
      postNote: "오랜만에 바둑 뒀어요. 재미있네요. 함께 바둑 공부할 사람 모집합니다.",
      countLikes: 0,
      countComment: 0,
      postImage:"https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.webp"
  ),
  PostVo(
      userThumbnail: "https://mblogthumb-phinf.pstatic.net/20160320_155/rabbitcat_14584632589491c2m0_JPEG/%BA%F1%BC%F5%C4%B3%B8%AF%C5%CD.jpg?type=w800",
      userNickname: "라이언",
      regionId: 1,
      categoryNames: 1,
      subCategory: 8,
      postNote: "오랜만에 바둑 뒀어요. 재미있네요. 함께 바둑 공부할 사람 모집합니다.",
      countLikes: 0,
      countComment: 0,
      postImage:"https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.webp"
  ),
  PostVo(
      userThumbnail: "https://mblogthumb-phinf.pstatic.net/20160320_155/rabbitcat_14584632589491c2m0_JPEG/%BA%F1%BC%F5%C4%B3%B8%AF%C5%CD.jpg?type=w800",
      userNickname: "라이언",
      regionId: 1,
      categoryNames: 1,
      subCategory: 8,
      postNote: "오랜만에 바둑 뒀어요. 재미있네요. 함께 바둑 공부할 사람 모집합니다.",
      countLikes: 0,
      countComment: 0,
      postImage:"https://flexible.img.hani.co.kr/flexible/normal/960/960/imgdb/resize/2019/0121/00501111_20190121.webp"
  )
];

//  카테고리 ID를 문자열로 변환
const Map<int, String> categoryNames = {1: "실내", 2: "실외"};

//  취미 ID를 문자열로 변환 (카테고리별로 따로 저장)
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

Map<int, String> regionMap = {
  1 : "서울특별시",
  2 : "인천광역시",
  3 : "대전광역시",
  4 : "대구광역시",
  5 : "울산광역시",
  6 : "부산광역시",
  7 : "광주광역시",
  8 : "세종특별자치시",
  9 : "제주도",
  10 : "울릉도"
};

class PostPage extends StatelessWidget {
  final PostVo? dummyPost;

  const PostPage({super.key, required this.dummyPost});

  @override
  Widget build(BuildContext context) {

    return MainLayout(
      child: Scaffold(
        // PreferredSize를 사용해 커스텀 앱바 구현
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "피드 페이지"),
        ),
        body:
            Container(
              color: const Color(0xFFF5F5F5),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 32),
                    postContainer(context),
                  ],
                ),
              ),
            ),
        ),
    );
  }
}

Widget postContainer(BuildContext context, {String title =''}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [SizedBox(height: 40,),
            ...dummyPostList.map((dummyPost) {
              return SizedBox(
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
                                radius: 30,
                                backgroundImage: NetworkImage(dummyPost.userThumbnail),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        dummyPost.userNickname,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                    Text(
                                      "${regionMap[dummyPost.regionId]!} · ${outdoorHobbies[dummyPost.subCategory]!}",
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          if (dummyPost.postImage != null && dummyPost.postImage!.isNotEmpty)
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
                          Text(dummyPost.postNote),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              LikeHeart(initialLikes: dummyPost.countLikes),

                              const SizedBox(width: 16),

                              Builder(
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    onTap: () {
                                      _showCommentModal(context);
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Icons.comment_outlined, size: 18, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text('${dummyPost.countComment}'),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                );
              }
            )
          ],
        )
      )
    ],
  );
}

// "준비중" 팝업 다이얼로그 함수
void _showComingSoonDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text("준비중"),
          content: const Text("해당 기능은 아직 준비중입니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        ),
  );
}

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

final TextEditingController _commentController = TextEditingController();
List<String> _comments = [];


void _showCommentModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder( // 👈 상태 변경을 위해 사용
        builder: (context, setModalState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('댓글', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),

                  Expanded(
                    child: _comments.isEmpty
                        ? const Center(child: Text("아직 등록된 댓글이 없습니다."))
                        : ListView.builder(
                      itemCount: _comments.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(_comments[index]),
                      ),
                    ),
                  ),

                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (_commentController.text.trim().isNotEmpty) {
                            setModalState(() {
                              _comments.add(_commentController.text.trim());
                              _commentController.clear();
                            });
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


