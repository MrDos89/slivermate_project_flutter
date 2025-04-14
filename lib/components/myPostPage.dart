import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/postVo.dart';
import 'package:slivermate_project_flutter/vo/commentVo.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:slivermate_project_flutter/pages/newPostPage.dart';
import 'package:slivermate_project_flutter/components/postContainer.dart';
import 'package:dio/dio.dart';

//  카테고리 ID를 문자열로 변환
const Map<int, String> postCategoryId = {1: "실내", 2: "실외"};

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

class MyPostPage extends StatefulWidget {
  final List<PostVo> myfeed;

  const MyPostPage({super.key, required this.myfeed});

  // 더미 데이터를 생성하는 static 함수
  static List<PostVo> generateDummyPosts() {
    return [
      PostVo(
        postId: 1,
        regionId: 1,
        postUserId: 1,
        clubId: 0,
        postCategoryId: 1,
        postSubCategoryId: 0, // 일상
        postNote: "반갑습니다!",
        postImages: [],
        postLikeCount: 2,
        postCommentCount: 1,
        isHidden: false,
        postReportCount: 0,
        registerDate: DateTime.now().subtract(const Duration(minutes: 5)),
        comments: [
          CommentVo(
            userThumbnail: "",
            userNickname: "아무개",
            commentText: "환영해요!",
            commentDate: DateTime.now().subtract(const Duration(minutes: 3)),
          ),
        ],
        // 추가된 required 매개변수들
        userNickname: "알파고",
        userThumbnail: "",
        updDate: DateTime.now(),
        likedByMe: false,
      ),
      PostVo(
        postId: 2,
        regionId: 3,
        postUserId: 2,
        clubId: 0,
        postCategoryId: 1,
        postSubCategoryId: 1, // 뜨개질
        postNote: "같이 놀아요",
        postImages: null,
        postLikeCount: 5,
        postCommentCount: 2,
        isHidden: false,
        postReportCount: 0,
        registerDate: DateTime.now().subtract(const Duration(minutes: 30)),
        comments: [
          CommentVo(
            userThumbnail: "",
            userNickname: "홍길동",
            commentText: "어렵지 않나요?",
            commentDate: DateTime.now().subtract(const Duration(minutes: 10)),
          ),
          CommentVo(
            userThumbnail: "",
            userNickname: "김영희",
            commentText: "저도 배우고 싶어요!",
            commentDate: DateTime.now().subtract(const Duration(minutes: 8)),
          ),
        ],
        userNickname: "홍길동",
        userThumbnail: "",
        updDate: DateTime.now(),
        likedByMe: true,
      ),
    ];
  }

  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  // 기존 지역 관련 변수 유지 (필요 시 사용)
  int? _selectedRegionId;
  Set<int> _selectedpostSubCategoryIdIds = {};
  late List<PostVo> postList = [];

  @override
  void initState() {
    super.initState();
    _refreshPostList();
  }

  // 실제 서버 데이터 가져오는 부분은 주석 처리
  Future<void> _refreshPostList() async {
    /*
    final fetchPostList = await PostService.fetchPostData();
    debugPrint(fetchPostList.toString());
    await Future.delayed(const Duration(seconds: 1));
    if (fetchPostList.isNotEmpty) {
      setState(() {
        postList = fetchPostList;
      });
    } else {
      debugPrint("포스트 리스트를 가져오지 못했습니다.");
    }
    */
    // 대신 더미 데이터를 직접 설정 (테스트용)
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      postList = widget.myfeed; // 전달받은 더미 데이터 사용
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
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '댓글',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child:
                          post.comments.isEmpty
                              ? const Center(child: Text("아직 등록된 댓글이 없습니다."))
                              : ListView.builder(
                                itemCount: post.comments.length,
                                itemBuilder: (context, index) {
                                  final comment = post.comments[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      radius: 16,
                                      backgroundImage: NetworkImage(
                                        comment.userThumbnail.trim().isEmpty
                                            ? defaultUserThumbnail
                                            : comment.userThumbnail,
                                      ),
                                    ),
                                    title: Text(
                                      comment.userNickname,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(comment.commentText),
                                    trailing: Text(
                                      "${comment.commentDate.hour}:${comment.commentDate.minute.toString().padLeft(2, '0')}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: '댓글을 입력하세요',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            if (commentController.text.trim().isNotEmpty) {
                              setModalState(() {
                                post.comments.add(
                                  CommentVo(
                                    userThumbnail: "",
                                    userNickname: "현재 사용자",
                                    commentText: commentController.text.trim(),
                                    commentDate: DateTime.now(),
                                  ),
                                );
                                commentController.clear();
                              });
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ),
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
    // 필터 없이 postList 전체 사용
    List<PostVo> filteredList =
        postList.where((post) {
          bool postSubCategoryIdMatch =
              _selectedpostSubCategoryIdIds.isEmpty ||
              _selectedpostSubCategoryIdIds.contains(post.postSubCategoryId);
          return postSubCategoryIdMatch;
        }).toList();

    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "내 피드"),
        ),
        body: Container(
          color: const Color(0xFFF5F5F5),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 카테고리 선택 (Chip 형태)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '카테고리',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 35,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  {
                                    ...indoorHobbies.entries,
                                    ...outdoorHobbies.entries,
                                  }.map((e) {
                                    final bool isSelected =
                                        _selectedpostSubCategoryIdIds.contains(
                                          e.key,
                                        );
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: FilterChip(
                                        label: Text(e.value),
                                        selected: isSelected,
                                        onSelected: (selected) {
                                          setState(() {
                                            if (e.key == -1) {
                                              if (selected) {
                                                _selectedpostSubCategoryIdIds
                                                    .clear();
                                              }
                                            } else {
                                              if (selected) {
                                                _selectedpostSubCategoryIdIds
                                                    .add(e.key);
                                                _selectedpostSubCategoryIdIds
                                                    .remove(-1);
                                              } else {
                                                _selectedpostSubCategoryIdIds
                                                    .remove(e.key);
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
                  child: postContainer(
                    context,
                    postList: filteredList,
                    onRefresh: _refreshPostList,
                    onLikeTap: (post) {
                      setState(() {
                        post.postLikeCount += 1;
                      });
                    },
                    onCommentTap: _showCommentModal,
                    currentUserId: 1,
                    setState: setState,
                  ),
                ),
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     // 기존 NewPostPage 대신 myPostPage를 호출하도록 변경
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder:
        //             (context) =>
        //                 MyPostPage(myfeed: MyPostPage.generateDummyPosts()),
        //       ),
        //     );
        //   },
        //   backgroundColor: Colors.green,
        //   shape: const CircleBorder(),
        // ),
      ),
    );
  }
}

// 유저 썸네일 기본 이미지
const String defaultUserThumbnail =
    "https://cdn.pixabay.com/photo/2023/09/13/07/29/ghost-8250317_640.png";

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
