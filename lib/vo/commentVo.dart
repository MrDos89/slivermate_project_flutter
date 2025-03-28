
class CommentVo {
  final String userThumbnail;  // 댓글 작성자의 썸네일
  final String userNickname;   // 댓글 작성자 닉네임
  final String commentText;    // 댓글 내용
  final DateTime commentDate;  // 댓글 작성일

  CommentVo({
    required this.userThumbnail,
    required this.userNickname,
    required this.commentText,
    required this.commentDate,
  });
}
