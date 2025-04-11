class CommentVo {
  final String userThumbnail;
  final String userNickname;
  final String commentText;
  final DateTime commentDate;

  CommentVo({
    required this.userThumbnail,
    required this.userNickname,
    required this.commentText,
    required this.commentDate,
  });

  /// JSON → CommentVo
  factory CommentVo.fromJson(Map<String, dynamic> json) {
    return CommentVo(
      userThumbnail: json['user_thumbnail'] ?? '',
      userNickname: json['nickname'] ?? '',
      commentText: json['content'] ?? '',
      commentDate: DateTime.parse(json['register_date']).toLocal(),
    );
  }

  /// CommentVo → JSON
  Map<String, dynamic> toJson() {
    return {
      'user_thumbnail': userThumbnail,
      'nickname': userNickname,
      'content': commentText,
      'register_date': commentDate.toIso8601String(),
    };
  }
}
