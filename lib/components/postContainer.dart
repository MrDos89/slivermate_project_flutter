import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:slivermate_project_flutter/vo/postVo.dart';
import 'package:slivermate_project_flutter/pages/postDetailPage.dart';
import 'package:slivermate_project_flutter/pages/postPage.dart';

// const String defaultUserThumbnail = "https://cdn.pixabay.com/photo/2023/09/13/07/29/ghost-8250317_640.png";

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

Widget postContainer(
  BuildContext context, {
  required List<PostVo> postList,
  required Future<void> Function() onRefresh,
  required void Function(PostVo post) onLikeTap,
  required void Function(BuildContext context, PostVo post) onCommentTap,
  bool isClubPage = false,
}) {
  final filteredList =
      isClubPage
          ? postList.where((post) => post.clubId != 0).toList()
          : postList.where((post) => post.clubId == 0).toList();

  if (filteredList.isEmpty) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
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

  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.71,
    child: RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        children:
            filteredList.map((post) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailPage(Post: post),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                post.userThumbnail.trim().isEmpty
                                    ? defaultUserThumbnail
                                    : post.userThumbnail,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.userNickname,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${regionMap[post.regionId]} · ${post.postCategoryId == 1 ? indoorHobbies[post.postSubCategoryId] : outdoorHobbies[post.postSubCategoryId]}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (hasValidImage(post)) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              post.postImages!.first,
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const SizedBox(), // 에러 안 뜨게
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        ReadMoreText(
                          post.postNote,
                          trimLines: 2,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' ...더보기',
                          trimExpandedText: ' 접기',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            LikeHeart(
                              initialLikes: post.postLikeCount,
                              initiallyLiked: false,
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => onCommentTap(context, post),
                              child: const Icon(
                                Icons.comment_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text("${post.comments.length}"),

                            const Spacer(), // 왼쪽 요소들 다 밀기

                            Text(
                              getTimeAgo(post.registerDate),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    ),
  );
}

bool hasValidImage(PostVo post) {
  final images = post.postImages;
  return images != null &&
      images.isNotEmpty &&
      images.first.trim().isNotEmpty &&
      (images.first.startsWith("http://") ||
          images.first.startsWith("https://"));
}
