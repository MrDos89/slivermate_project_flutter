import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/postVo.dart';
import 'package:slivermate_project_flutter/vo/commentVo.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:slivermate_project_flutter/pages/newPostPage.dart';
import 'package:slivermate_project_flutter/components/postContainer.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:slivermate_project_flutter/components/userProvider.dart';


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

class PostPage extends StatefulWidget {
  final PostVo? dummyPost;

  const PostPage({super.key, this.dummyPost});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int? _selectedRegionId; // 지역
  Set<int> _selectedpostSubCategoryIdIds = {};
  late List<PostVo> postList = [];

  @override
  void initState() {
    super.initState();

    _refreshPostList();
  }

  Future<void> _refreshPostList() async {
    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    debugPrint("현재 로그인 유저 UID: ${currentUser?.uid}, 닉네임: ${currentUser?.nickname}");

    final userVo = Provider.of<UserProvider>(context, listen: false).user;

    if (userVo == null) {
      debugPrint("유저 정보가 없습니다. 포스트를 불러올 수 없습니다.");
      return;
    }

    final fetchPostList = await PostService.fetchPostsWithLikes(userVo.uid);

    debugPrint(fetchPostList.toString());
    await Future.delayed(const Duration(seconds: 1)); // 리프레시 느낌

    if (fetchPostList.isNotEmpty) {
      setState(() {
        postList = fetchPostList;
      });
    } else {
      debugPrint("포스트 리스트를 가져오지 못했습니다.");
    }
  }


  void _showCommentModal(BuildContext context, PostVo post) async {
    final TextEditingController commentController = TextEditingController();

    // ✅ 댓글 새로 불러오기
    final updatedComments = await CommentService.fetchComments(post.postId);
    post.comments = updatedComments;

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
                    const Text("댓글", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    Expanded(
                      child: (post.comments ?? []).isEmpty
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
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(comment.commentText),
                            trailing: Text(
                              "${comment.commentDate.hour}:${comment.commentDate.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                          onPressed: () async {
                            final userVo = Provider.of<UserProvider>(context, listen: false).user;

                            if (commentController.text.trim().isNotEmpty && userVo != null) {
                              final success = await CommentService.addComment(
                                postId: post.postId,
                                userId: userVo.uid,
                                clubId: post.clubId,
                                commentText: commentController.text.trim(),
                              );

                              if (success) {
                                final newComments = await CommentService.fetchComments(post.postId);

                                setModalState(() {
                                  post.comments = newComments;
                                  commentController.clear();
                                });

                                setState(() {}); // 외부 리스트 갱신
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("댓글 등록에 실패했습니다.")),
                                );
                              }
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
    final userVo = Provider.of<UserProvider>(context).user;

    List<PostVo> filteredList =
        postList.where((post) {
          // bool isClubPost = post.clubId != 0;

          bool regionMatch =
              _selectedRegionId == null || post.regionId == _selectedRegionId;

          bool postSubCategoryIdMatch =
              _selectedpostSubCategoryIdIds.isEmpty ||
              _selectedpostSubCategoryIdIds.contains(post.postSubCategoryId);

          return regionMatch && postSubCategoryIdMatch;
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: RegionDropdown(
                    value: _selectedRegionId,
                    onChanged: (value) {
                      setState(() {
                        _selectedRegionId = value; // null 허용됨
                      });
                    },
                  ),
                ),
                // const SizedBox(height: ),

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
                          height: 35, // 칩 높이 제한
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal, // 가로 슬라이드 활성화
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
                                              // '전체' 선택 시 모든 선택 초기화
                                              if (selected) {
                                                _selectedpostSubCategoryIdIds
                                                    .clear();
                                              }
                                            } else {
                                              if (selected) {
                                                _selectedpostSubCategoryIdIds
                                                    .add(e.key);
                                                _selectedpostSubCategoryIdIds
                                                    .remove(
                                                      -1,
                                                    ); // 다른 항목 선택 시 '전체' 제거
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
                    currentUserId: userVo?.uid ?? 0,
                    setState: setState,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewPostPage()),
            );

            // 글 작성 후 돌아왔을 때 새로고침
            if (result == true) {
              debugPrint("새 글 작성됨 → 자동 새로고침 시작");
              await _refreshPostList();

              // 리스트 가장 위로 스크롤
              if (mounted) {
                Scrollable.ensureVisible(
                  context,
                  duration: const Duration(milliseconds: 300),
                  alignment: 0.0,
                );
              }
            }
          },
          backgroundColor: Colors.green,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
      ),
    );
  }
}

String getTimeAgo(DateTime date) {
  final now = DateTime.now().toLocal();
  final diff = now.difference(date);

  if (diff.inMinutes < 0) return "방금 전";

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


// final postUserThumbnail =
//     (dummyPostList[0].userThumbnail.trim().isEmpty)
//         ? defaultUserThumbnail
//         : dummyPostList[0].userThumbnail;

// 유저 썸네일 기본 이미지, 설정 안했을 경우 나올 이미지 설정
const String defaultUserThumbnail =
    "https://cdn.pixabay.com/photo/2023/09/13/07/29/ghost-8250317_640.png";

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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
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
          color: Color(0xFFF5F5F5),
          border: Border.all(color: Colors.grey.shade100),
        ),
      ),
    );
  }
}
