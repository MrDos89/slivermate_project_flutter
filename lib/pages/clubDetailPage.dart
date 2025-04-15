import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/postVo.dart';
import 'package:slivermate_project_flutter/pages/postPage.dart';
import 'package:slivermate_project_flutter/components/postContainer.dart';
import 'package:slivermate_project_flutter/pages/postDetailPage.dart';
import 'package:slivermate_project_flutter/pages/newClubPostPage.dart';
import 'package:slivermate_project_flutter/vo/commentVo.dart';
import 'package:slivermate_project_flutter/vo/clubVo.dart';
import 'package:provider/provider.dart';
import 'package:slivermate_project_flutter/components/userProvider.dart';
import 'package:slivermate_project_flutter/components/scheduleSection.dart';
import 'package:intl/intl.dart';


class ClubDetailPage extends StatefulWidget {
  final ClubVo clubVo;
  const ClubDetailPage({super.key, required this.clubVo});

  @override
  State<ClubDetailPage> createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  List<PostVo> clubPosts = [];
  bool _isLoading = true;
  bool _isJoined = false;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchClubPosts();
  }

  Future<void> fetchClubPosts() async {
    setState(() => _isLoading = true);
    try {
      final userVo = Provider.of<UserProvider>(context, listen: false).user;
      final userId = userVo?.uid ?? 0;
      final allPosts = await PostService.fetchPostData(userId);
      final filtered = allPosts.where((post) => post.clubId == widget.clubVo.clubId).toList();
      setState(() {
        clubPosts = filtered;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('🚨 게시글 로딩 실패: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshClubPosts() async {
    await fetchClubPosts();
  }

  Widget _buildTabContent() {
    final userVo = Provider.of<UserProvider>(context, listen: false).user;
    final currentUserId = userVo?.uid ?? 0;
    switch (_selectedTabIndex) {
      case 0:
        return _buildIntroSection();
      case 1:
        return SizedBox(
          height: 400,
          child: postContainer(
            context,
            postList: clubPosts,
            onRefresh: _refreshClubPosts,
            onLikeTap: (post) {
              setState(() => post.postLikeCount += 1);
            },
            onCommentTap: _showCommentModal,
            currentUserId: currentUserId,
            isClubPage: true,
            setState: setState,
          ),
        );
      case 2:
        final imagePosts = clubPosts.where((p) => p.postImages!.isNotEmpty).toList();
        if (imagePosts.isEmpty) {
          return SizedBox(
            height: 300,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.photo_library_outlined, size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text("등록된 사진이 없습니다.", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 6),
                  Text("사진이 포함된 게시물을 올려주세요.", style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: imagePosts.length,
            itemBuilder: (context, index) {
              final post = imagePosts[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PostDetailPage(Post: post)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.postImages!.first,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        );
      case 3:
        return ScheduleSection(
          clubId: widget.clubVo.clubId,
          clubLeaderId: widget.clubVo.clubUserId,
          currentUserId: currentUserId,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // [yj] 댓글 모달
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

                    // 댓글 입력 필드
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
                                    userThumbnail: "", // 현재 사용자 프로필 이미지
                                    userNickname: "현재 사용자", // 현재 사용자 닉네임
                                    commentText: commentController.text.trim(),
                                    commentDate: DateTime.now(),
                                  ),
                                );
                                commentController.clear();
                              });

                              setState(() {}); // 메인 화면 업데이트
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

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.green : Colors.black54,
          ),
        ),
      ),
    );
  }

  // Widget _buildTabContent() {
  //   final userVo = Provider.of<UserProvider>(context, listen: false).user;
  //   final currentUserId = userVo?.uid ?? 0;
  //
  //   switch (_selectedTabIndex) {
  //     case 0:
  //       return _buildIntroSection();
  //     case 1:
  //       // final clubId = widget.clubVo.clubId;
  //       // final clubPosts =
  //       // widget.postList.where((p) => p.clubId == clubId).toList();
  //
  //       return SizedBox(
  //         height: 400,
  //         child: postContainer(
  //           context,
  //           postList: clubPosts,
  //           onRefresh: _refreshClubPosts,
  //           onLikeTap: (post) {
  //             setState(() {
  //               post.postLikeCount += 1;
  //             });
  //           },
  //           onCommentTap: _showCommentModal,
  //           currentUserId: 1,
  //           isClubPage: true,
  //           setState: setState,
  //         ),
  //       );
  //     case 2:
  //       // final clubId = widget.clubVo.clubId;
  //       final imagePosts =
  //           clubPosts.where((p) => p.postImages!.isNotEmpty).toList();
  //
  //       if (imagePosts.isEmpty) {
  //         return SizedBox(
  //           height: 300,
  //           child: Center(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 const Icon(
  //                   Icons.photo_library_outlined,
  //                   size: 60,
  //                   color: Colors.grey,
  //                 ),
  //                 const SizedBox(height: 12),
  //                 Text(
  //                   "등록된 사진이 없습니다.",
  //                   style: TextStyle(fontSize: 16, color: Colors.grey[700]),
  //                 ),
  //                 const SizedBox(height: 6),
  //                 Text(
  //                   "사진이 포함된 게시물을 올려주세요.",
  //                   style: TextStyle(fontSize: 14, color: Colors.grey),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }
  //
  //       return Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: GridView.builder(
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 3, // 3개씩 한 줄
  //             mainAxisSpacing: 8,
  //             crossAxisSpacing: 8,
  //             childAspectRatio: 1,
  //           ),
  //           itemCount: imagePosts.length,
  //           itemBuilder: (context, index) {
  //             final post = imagePosts[index];
  //             return GestureDetector(
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (_) => PostDetailPage(Post: post),
  //                   ),
  //                 );
  //               },
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(8),
  //                 child: Image.network(
  //                   post.postImages!.first,
  //                   width: double.infinity,
  //                   height: 250,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     case 3:
  //       return _buildScheduleSection(
  //         clubId: widget.clubVo.clubId,
  //         clubLeaderId: widget.clubVo.clubUserId,
  //         currentUserId: currentUserId,
  //       );
  //     default:
  //       return const SizedBox.shrink();
  //   }
  // }

  Widget _buildIntroSection() {
    final String name = widget.clubVo.clubName.toString();
    final DateTime createdAt = widget.clubVo.clubRegisterDate;
    final String formattedDate = DateFormat('yyyy.MM.dd').format(createdAt);
    final int clubUserId = widget.clubVo.clubUserId as int? ?? 0;
    final String clubUserNickname = widget.clubVo.clubUserNickname ?? "알 수 없음";
    final int memberCount = widget.clubVo.clubMemberNumber as int? ?? 0;
    final int maxCount = widget.clubVo.clubMemberMax as int? ?? 0;
    final String description = widget.clubVo.clubDesc.toString();


    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "개설일: $formattedDate",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 4),
                  Text(
                    "모임장: ${widget.clubVo.clubUserNickname ?? "알 수 없음"}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(
                    Icons.workspace_premium,
                    color: Colors.amber,
                    size: 20,
                  ),
                ],
              ),
              Text(
                "인원: $memberCount / $maxCount명",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(description, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    final String thumbnailUrl = widget.clubVo.clubThumbnail.trim();

    final ImageProvider imageProvider = thumbnailUrl.isNotEmpty
        ? NetworkImage(thumbnailUrl)
        : const AssetImage('lib/images/club.avif');

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Image(
        image: imageProvider,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userVo = Provider.of<UserProvider>(context).user;
    final currentUserId = userVo?.uid ?? 0;
    final isLeader = widget.clubVo.clubUserId == currentUserId;

    return Stack(
      children: [
        MainLayout(
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: const HeaderPage(pageTitle: "모임 상세", showBackButton: true),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildThumbnail(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTabButton("소개", 0),
                        _buildTabButton("피드", 1),
                        _buildTabButton("사진", 2),
                        _buildTabButton("일정", 3),
                      ],
                    ),
                  ),
                  _buildTabContent(),
                ],
              ),
            ),
            // 여기선 FAB 삭제!
          ),
        ),

        Positioned(
          bottom: 80,
          right: 16,
          child: !_isJoined && !isLeader
              ? FloatingActionButton(
            onPressed: () {
              setState(() {
                _isJoined = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("모임에 가입되었습니다!")),
              );
            },
            backgroundColor: Colors.green,
            shape: const CircleBorder(),
            child: const Text(
              "가입하기",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
              : isLeader
              ? FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      NewClubPostPage(clubId: widget.clubVo.clubId),
                ),
              );
              if (result == true) {
                await _refreshClubPosts();
              }
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.edit, color: Colors.white),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}