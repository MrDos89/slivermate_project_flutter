class SignupVo {
  final String userName;
  final String nickname;
  final String userId;
  final String userPassword;
  final String pinPassword;
  final String telNumber;
  final String email;
  final int regionId;
  final int userType;

  SignupVo({
    required this.userName,
    required this.nickname,
    required this.userId,
    required this.userPassword,
    required this.pinPassword,
    required this.telNumber,
    required this.email,
    required this.regionId,
    this.userType = 1,
  });

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'nickname': nickname,
    'userId': userId,
    'userPassword': userPassword,
    'pinPassword': pinPassword,
    'telNumber': telNumber,
    'email': email,
    'regionId': regionId,
    'userType': userType,
  };
}
