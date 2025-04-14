import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/vo/postVo.dart';
import 'package:slivermate_project_flutter/vo/commentVo.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/pages/postPage.dart';
import 'package:provider/provider.dart';
import 'package:slivermate_project_flutter/components/userProvider.dart';
import 'package:dio/dio.dart';

// const String defaultUserThumbnail = "https://yourdomain.com/default_profile.png"; // 기본 이미지 URL

//  취미 ID를 문자열로 변환 (카테고리별로 따로 저장)
const Map<int, String> indoorHobbies = {
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
  2: "인천광역시",
  3: "대전광역시",
  4: "대구광역시",
  5: "울산광역시",
  6: "부산광역시",
  7: "광주광역시",
  8: "세종특별자치시",
  9: "제주도",
  10: "울릉도",
};

class PostDetailPage extends StatefulWidget {
  final PostVo Post;

  const PostDetailPage({super.key, required this.Post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late int likeCount;
  bool isLiked = false;

  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    likeCount = widget.Post.postLikeCount;
    isLiked = widget.Post.likedByMe;
  }

  Future<void> _toggleLike() async {
    final prevLiked = isLiked;
    final prevLikes = likeCount;

    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
      widget.Post.likedByMe = isLiked; // PostVo도 동기화
      widget.Post.postLikeCount = likeCount;
    });

    try {
      final dio = Dio();
      final response = await dio.patch(
        'http://43.201.50.194:18090/api/post/updateCount',
        queryParameters: {
          'post_id': widget.Post.postId,
          'liked_by_me': isLiked,
        },
      );

      if (response.statusCode != 200) {
        throw Exception("서버 반영 실패");
      }
    } catch (e) {
      // 롤백
      setState(() {
        isLiked = prevLiked;
        likeCount = prevLikes;
        widget.Post.likedByMe = prevLiked;
        widget.Post.postLikeCount = prevLikes;
      });
      print("❌ 좋아요 토글 실패: $e");
    }
  }


  void _addComment() async {
    final text = _commentController.text.trim();
    final userVo = Provider.of<UserProvider>(context, listen: false).user;

    if (text.isNotEmpty && userVo != null) {
      final success = await CommentService.addComment(
        postId: widget.Post.postId,
        userId: userVo.uid,
        clubId: widget.Post.clubId,
        commentText: text,
      );

      if (success) {
        setState(() {
          widget.Post.comments.add(
            CommentVo(
              userThumbnail: userVo.thumbnail.trim().isEmpty
                  ? defaultUserThumbnail
                  : userVo.thumbnail,
              userNickname: userVo.nickname,
              commentText: text,
              commentDate: DateTime.now(),
            ),
          );
          _commentController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ 댓글 등록 실패")),
        );
      }
    }
  }



  // String defaultUserThumbnail = "https://cdn.pixabay.com/photo/2023/09/13/07/29/ghost-8250317_640.png";

  @override
  Widget build(BuildContext context) {
    final post = widget.Post;
    final postUserThumbnail =
        post.userThumbnail.trim().isEmpty
            ? defaultUserThumbnail
            : post.userThumbnail;
    final validImages =
        post.postImages
            ?.where(
              (img) =>
                  img.trim().isNotEmpty &&
                  (img.startsWith("http://") || img.startsWith("https://")),
            )
            .toList();

    return MainLayout(
      child: Scaffold(
        appBar: const HeaderPage(pageTitle: "게시글", showBackButton: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (validImages != null && validImages.isNotEmpty) ...[
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      validImages.map((imageUrl) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const SizedBox(),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(postUserThumbnail),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userNickname,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "지역: ${regionMap[post.regionId]}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(post.postNote, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                children: [
                  GestureDetector(
                    onTap: _toggleLike,
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text('$likeCount'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.comment_outlined,
                    color: Colors.grey,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text('${post.comments.length}'),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "댓글",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              post.comments.isEmpty
                  ? const Center(
                    child: Text(
                      "아직 댓글이 없습니다",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: post.comments.length,
                    itemBuilder: (context, index) {
                      final comment = post.comments[index];
                      final profileImage =
                          comment.userThumbnail.trim().isEmpty
                              ? defaultUserThumbnail
                              : comment.userThumbnail;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(profileImage),
                        ),
                        title: Text(
                          comment.userNickname,
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
              const SizedBox(height: 80), // 댓글 입력창과 겹치지 않도록 여백 확보
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: "댓글을 입력하세요",
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _addComment,
              ),
              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ),
    );
  }
}
