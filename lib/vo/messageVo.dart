class MessageVo {
  final String sender;
  final String nickname;
  final String thumbnail;
  final String message;
  final DateTime updDate;

  MessageVo({
    required this.sender,
    required this.nickname,
    required this.thumbnail,
    required this.message,
    required this.updDate,
  });
}
