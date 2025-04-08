import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:slivermate_project_flutter/components/uploadImage.dart';

List<Map<String, dynamic>> groupAccounts = [
  {'nickname': '엄마', 'userType': 1},
  {'nickname': '아빠', 'userType': 1},
  {'nickname': '아들', 'userType': 3},
];

class SignUpPage2 extends StatefulWidget {
  final List<UserVo> userList;
  const SignUpPage2({super.key, required this.userList});

  @override
  State<SignUpPage2> createState() => _SignUpPageState();
}

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

void _completeSignup(BuildContext context, List<UserVo> userList) {
  if (userList.isEmpty) return;

  final baseUser = userList.first; // 기존 계정 정보 참조

  final newUser = UserVo(
    uid: DateTime.now().millisecondsSinceEpoch, // 임시 고유값
    userName: baseUser.userName,
    nickname: "새 계정",
    userId: baseUser.userId,
    userPassword: baseUser.userPassword,
    pinPassword: baseUser.pinPassword,
    telNumber: baseUser.telNumber,
    email: baseUser.email,
    thumbnail: "",
    regionId: baseUser.regionId,
    // recommendUid: baseUser.recommendUid,
    registerDate: DateTime.now(),
    isDeleted: false,
    isAdmin: false,
    updDate: DateTime.now(),
    groupId: baseUser.groupId,
    userType: 2, // 새 역할만 바뀜
  );

  userList.add(newUser);

  Navigator.pushReplacementNamed(
    context,
    '/selectAccount',
    arguments: userList,
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("역할 추가")),
    body: Center(
      child: ElevatedButton(
        onPressed: () => _completeSignup,
        child: const Text("새 계정 추가하기"),
      ),
    ),
  );
}

class _SignUpPageState extends State<SignUpPage2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController pinPasswordController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();

  bool isPinMatching = true;
  bool isPasswordMatching = true;

  String userName = '';
  String nickname = '';
  String userId = '';
  String userPassword = '';
  String pinPassword = '';
  String telNumber = '';
  String email = '';
  int? regionId = 1;
  int userType = 1;

  String? thumbnail;

  void handleImageUpload(String imageUrl) {
    setState(() {
      thumbnail = imageUrl;
    });
  }

  @override
  void initState() {
    super.initState();

    // 두 입력 값이 변할 때마다 비교해서 상태 업데이트
    pinPasswordController.addListener(_validatePinMatch);
    confirmPinController.addListener(_validatePinMatch);
  }

  // [yj] 핀 번호, 핀 번호 확인
  void _validatePinMatch() {
    setState(() {
      isPinMatching = pinPasswordController.text == confirmPinController.text;
    });
  }

  // [yj] 유저 타입1 최대 2개 제한 걸기
  int getTotalParentCount() {
    // userType 1(엄마), 2(아빠) 포함
    return groupAccounts
        .where((user) => user['userType'] == 1 || user['userType'] == 2)
        .length;
  }

  void _onUserTypeChanged(int? newType) {
    if ((newType == 1 || newType == 2) && getTotalParentCount() >= 2) {
      _showDialog('제한', '엄마/아빠 계정은 최대 2명까지만 등록할 수 있어요.');
      return;
    }
    setState(() {
      userType = newType ?? 1;
    });
  }

  @override
  void dispose() {
    pinPasswordController.dispose();
    confirmPinController.dispose();
    super.dispose();
  }

  // [yj] 닉네임 중복 확인 함수
  Future<bool> checkNicknameAvailable(String nickname) async {
    await Future.delayed(const Duration(milliseconds: 500)); // 서버 응답 대기 시뮬레이션

    // TODO: 서버 연동되면 여기를 http.post 또는 get으로 교체

    // 예시: 닉네임이 'test'이면 중복 처리
    if (nickname == 'test') return false;
    return true;
  }

  void _checkNicknameDuplication() async {
    final nicknameText = nicknameController.text.trim();

    if (nicknameText.isEmpty) {
      _showDialog('오류', '닉네임을 입력해주세요.');
      return;
    }

    final available = await checkNicknameAvailable(nicknameText);

    if (available) {
      _showDialog('확인', '사용 가능한 닉네임입니다.');
    } else {
      _showDialog('중복', '이미 사용 중인 닉네임입니다.');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userList = ModalRoute.of(context)!.settings.arguments as List<UserVo>;

    return MainLayout(
      child: Column(
        children: [
          const HeaderPage(pageTitle: "계정생성", showBackButton: true),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    UploadImage(onUpload: handleImageUpload),
                    TextFormField(
                      decoration: const InputDecoration(labelText: '이름'),
                      onSaved: (value) => userName = value ?? '',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? '이름을 입력해주세요.'
                                  : null,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3, // 입력칸 넓이 비율
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: '닉네임'),
                            onSaved: (value) => nickname = value ?? '',
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? '닉네임을 입력해주세요.'
                                        : null,
                            controller: nicknameController,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _checkNicknameDuplication,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              backgroundColor: const Color(
                                0xFFE0F8DF,
                              ).withAlpha(128),
                            ),
                            child: const Text('중복 확인'),
                          ),
                        ),
                      ],
                    ),
                    // [yj] 핀 번호 설정
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: pinPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'PIN 번호',
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          onSaved: (value) => pinPassword = value ?? '',
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? '핀 번호를 입력해주세요.'
                                      : null,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '계정 비밀번호 설정입니다.',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: confirmPinController,
                          decoration: const InputDecoration(
                            labelText: 'PIN 번호 확인',
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          onSaved: (value) => pinPassword = value ?? '',
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? '핀 번호를 한 번 더 입력 해주세요.'
                                      : null,
                        ),
                        const SizedBox(height: 4),
                        if (!isPinMatching)
                          Row(
                            children: const [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'PIN 번호가 다릅니다',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: '전화번호'),
                      keyboardType: TextInputType.phone,
                      onSaved: (value) => telNumber = value ?? '',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? '전화번호를 입력해주세요.'
                                  : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: '이메일'),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => email = value ?? '',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? '이메일을 입력해주세요.'
                                  : null,
                    ),
                    const SizedBox(height: 10),
                    RegionDropdown(
                      value: regionId,
                      onChanged: (val) => setState(() => regionId = val),
                      onSaved: (val) => regionId = val ?? 0,
                    ),
                    const SizedBox(height: 20),
                    UserTypeDropdown(
                      value: userType,
                      onChanged: _onUserTypeChanged,
                      onSaved: (val) => userType = val ?? 1,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // 먼저 입력값 검증
                        if (_formKey.currentState?.validate() ?? false) {
                          // 검증 통과 시 입력값 저장
                          _formKey.currentState?.save();

                          // 디버깅 출력
                          debugPrint('회원가입 정보:');
                          debugPrint('이름: $userName, 닉네임: $nickname');
                          debugPrint('PIN: $pinPassword');
                          debugPrint(
                            '전화: $telNumber, 이메일: $email, 지역: $regionId',
                          );
                          debugPrint('유저타입: $userType');

                          // 계정 추가 성공 모달 띄우기
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('계정 추가 완료'),
                                content: const Text('계정 추가에 성공했습니다!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/selectAccount',
                                        arguments: userList,
                                      );
                                    },
                                    child: const Text('확인'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // 유효성 검증 실패 시 안내
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('입력되지 않은 정보가 있습니다.')),
                          );
                        }
                      },
                      child: const Text('계정추가'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// [yj] 지역 선택 드롭 다운 박스 위젯
class RegionDropdown extends StatelessWidget {
  final int? value;
  final void Function(int?) onChanged;
  final void Function(int?)? onSaved;

  const RegionDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<int>(
      isExpanded: true,
      alignment: Alignment.centerLeft,
      decoration: const InputDecoration(
        labelText: '지역 선택',
        border: OutlineInputBorder(),
        isDense: true,
        // contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      value: value,
      items:
          regionMap.entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(entry.value),
              ),
            );
          }).toList(),
      onChanged: onChanged,
      onSaved: onSaved,
      buttonStyleData: const ButtonStyleData(
        height: 25,
        // padding: EdgeInsets.symmetric(horizontal: 4),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 20,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all(true),
        ),
      ),
    );
  }
}

// [yj] 유저 유형 드롭다운 위젯
class UserTypeDropdown extends StatelessWidget {
  final int? value;
  final void Function(int?) onChanged;
  final void Function(int?)? onSaved;

  const UserTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<int>(
      isExpanded: true,
      alignment: Alignment.centerLeft,
      decoration: const InputDecoration(
        labelText: '유저 유형',
        border: OutlineInputBorder(),
        isDense: true,
        // contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      value: value,
      items: const [
        DropdownMenuItem(
          value: 1,
          child: Align(alignment: Alignment.centerLeft, child: Text('엄마')),
        ),
        DropdownMenuItem(
          value: 2,
          child: Align(alignment: Alignment.centerLeft, child: Text('아빠')),
        ),
        DropdownMenuItem(
          value: 3,
          child: Align(alignment: Alignment.centerLeft, child: Text('아들')),
        ),
        DropdownMenuItem(
          value: 4,
          child: Align(alignment: Alignment.centerLeft, child: Text('딸')),
        ),
      ],
      onChanged: onChanged,
      onSaved: onSaved,
      buttonStyleData: const ButtonStyleData(
        height: 25,
        // padding: EdgeInsets.symmetric(horizontal: 4),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 20,
        iconEnabledColor: Colors.black,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
        ),
        elevation: 3,
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStatePropertyAll(true),
        ),
      ),
    );
  }
}
