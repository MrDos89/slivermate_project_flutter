import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

Map<int, String> regionMap = {
  1 : "서울특별시",
  2 : "인천광역시",
  3 : "대전광역시",
  4 : "대구광역시",
  5 : "울산광역시",
  6 : "부산광역시",
  7 : "광주광역시",
  8 : "세종특별자치시",
  9 : "제주도",
  10 : "울릉도"
};

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();

  String userName = '';
  String nickname = '';
  String userId = '';
  String userPassword = '';
  String pinPassword = '';
  String telNumber = '';
  String email = '';
  int? regionId;
  int userType = 1;

  // [yj] 닉네임 중복 확인 함수
  void _checkNicknameDuplication() {
    final nicknameText = nicknameController.text.trim();

    if (nicknameText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임을 입력해주세요.')),
      );
      return;
    }

    // TODO: 실제 서버와 중복 확인 로직 추가
    debugPrint('닉네임 중복 확인 요청: $nicknameText');

    // 예시 응답 처리
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('사용 가능한 닉네임입니다.')),
    );
  }

  // [yj] 아이디 중복 확인 함수
  void _checkUserIdDuplication() {
    final idText = userIdController.text.trim();

    if (idText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디를 입력해주세요.')),
      );
      return;
    }

    // TODO: 실제 서버에 중복 확인 요청 보내기
    debugPrint('아이디 중복 확인 요청: $idText');

    // 예시 응답 처리
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('사용 가능한 아이디입니다.')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          const HeaderPage(pageTitle: "회원가입", showBackButton: true),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: '이름'),
                      onSaved: (value) => userName = value ?? '',
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3, // 입력칸 넓이 비율
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: '닉네임'),
                            onSaved: (value) => nickname = value ?? '',
                            controller: nicknameController,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _checkNicknameDuplication,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              backgroundColor: const Color(0xFFE0F8DF).withAlpha(128),
                            ),
                            child: const Text('중복 확인'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: '아이디'),
                            controller: userIdController,
                            onSaved: (value) => userId = value ?? '',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          // flex: 1,
                          child: ElevatedButton(
                            onPressed: _checkUserIdDuplication,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              backgroundColor: const Color(0xFFE0F8DF).withAlpha(128),
                            ),
                            child: const Text('중복 확인'),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: '비밀번호'),
                      obscureText: true,
                      onSaved: (value) => userPassword = value ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: '비밀번호 확인'),
                      obscureText: true,
                      onSaved: (value) => userPassword = value ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'PIN 비밀번호'),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      onSaved: (value) => pinPassword = value ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'PIN 비밀번호 확인'),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      onSaved: (value) => pinPassword = value ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: '전화번호'),
                      keyboardType: TextInputType.phone,
                      onSaved: (value) => telNumber = value ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: '이메일'),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => email = value ?? '',
                    ),
                    const SizedBox(height: 10),
                    RegionDropdown(
                      value: regionId,
                      onChanged: (val) => setState(() => regionId = val),
                      onSaved: (val) => regionId = val ?? 0,
                    ),
                    const SizedBox(height: 20),
                    // UserTypeDropdown(
                    //   value: userType,
                    //   onChanged: (val) => setState(() => userType = val ?? 1),
                    //   onSaved: (val) => userType = val ?? 1,
                    // ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _formKey.currentState?.save();
                        debugPrint('회원가입 정보:');
                        debugPrint('이름: $userName, 닉네임: $nickname');
                        debugPrint('아이디: $userId, 비번: $userPassword, PIN: $pinPassword');
                        debugPrint('전화: $telNumber, 이메일: $email, 지역: $regionId');
                        // debugPrint('유저타입: $userType');
                      },
                      child: const Text('회원가입'),
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
      items: regionMap.entries.map((entry) {
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
// class UserTypeDropdown extends StatelessWidget {
//   final int? value;
//   final void Function(int?) onChanged;
//   final void Function(int?)? onSaved;
//
//   const UserTypeDropdown({
//     super.key,
//     required this.value,
//     required this.onChanged,
//     this.onSaved,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField2<int>(
//       isExpanded: true,
//       alignment: Alignment.centerLeft,
//       decoration: const InputDecoration(
//         labelText: '유저 유형',
//         border: OutlineInputBorder(),
//         isDense: true,
//         // contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       ),
//       value: value,
//       items: const [
//         DropdownMenuItem(
//           value: 1,
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text('엄마'),
//           ),
//         ),
//         DropdownMenuItem(
//           value: 2,
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text('아빠'),
//           ),
//         ),
//         DropdownMenuItem(
//           value: 3,
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text('첫째'),
//           ),
//         ),
//         DropdownMenuItem(
//           value: 4,
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text('둘째'),
//           ),
//         ),
//       ],
//       onChanged: onChanged,
//       onSaved: onSaved,
//       buttonStyleData: const ButtonStyleData(
//         height: 25,
//         // padding: EdgeInsets.symmetric(horizontal: 4),
//       ),
//       iconStyleData: const IconStyleData(
//         icon: Icon(Icons.arrow_drop_down),
//         iconSize: 20,
//         iconEnabledColor: Colors.black,
//       ),
//       dropdownStyleData: DropdownStyleData(
//         maxHeight: 180,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.all(Radius.circular(4)),
//           border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
//         ),
//         elevation: 3,
//         scrollbarTheme: ScrollbarThemeData(
//           thumbVisibility: WidgetStatePropertyAll(true),
//         ),
//       ),
//     );
//   }
// }

