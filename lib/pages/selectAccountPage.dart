import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:slivermate_project_flutter/pages/signUpPage2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:slivermate_project_flutter/components/userProvider.dart';

class SelectAccountPage extends StatefulWidget {
  final List<UserVo> userList;

  const SelectAccountPage({super.key, required this.userList});

  @override
  State<SelectAccountPage> createState() => _SelectAccountPageState();
}

class _SelectAccountPageState extends State<SelectAccountPage> {
  late List<UserVo> _accounts;
  UserVo? _selectedUser;
  String _pinInput = "";

  static String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  static String ec2Port = dotenv.get("EC2_PORT");
  static final Dio dio = Dio();
  static String userGroupUrl = "http://$ec2IpAddress:$ec2Port/api/usergroup";
  static String sessionCheckUrl =
      "http://$ec2IpAddress:$ec2Port/api/user/session";

  late PersistCookieJar cookieJar;

  @override
  void initState() {
    super.initState();
    _accounts = widget.userList;
    _initDioAndCheckLogin();
  }

  Future<void> _initDioAndCheckLogin() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      storage: FileStorage("${appDocDir.path}/.cookies/"),
    );
    dio.interceptors.add(CookieManager(cookieJar));
    await checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      final response = await dio.get(sessionCheckUrl);
      if (response.statusCode == 200) {
        print("로그인 유지됨 - 사용자: ${UserVo.fromJson(response.data)}");
      } else {
        print("로그인되지 않음.");
      }
    } catch (error) {
      print('로그인 상태 확인 중 오류 발생: $error');
    }
  }

  void _showPinDialog(UserVo user) {
    setState(() {
      _selectedUser = user;
      _pinInput = "";
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("${user.nickname}님의 비밀번호"),
          content: TextField(
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'PIN을 입력하세요'),
            onChanged: (value) {
              _pinInput = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _submitPinPassword(user);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitPinPassword(UserVo user) async {
    try {
      final response = await dio.post(
        "$userGroupUrl/login/${user.groupId}/${user.uid}",
        data: {"pin_password": _pinInput},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        final userData = UserVo.fromJson(response.data);
        Provider.of<UserProvider>(context, listen: false).setUser(userData);
        Navigator.pushReplacementNamed(context, '/userprofile');
      } else {
        _showErrorSnackbar("PIN이 올바르지 않습니다.");
      }
    } catch (e) {
      debugPrint("로그인 오류: $e");
      _showErrorSnackbar("서버와의 통신에 실패했습니다.");
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('계정 선택')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount:
              _accounts.length < 4 ? _accounts.length + 1 : _accounts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            if (_accounts.length < 4 && index == _accounts.length) {
              return GestureDetector(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/signUpPage2',
                    arguments: _accounts,
                  );

                  if (result is List<UserVo>) {
                    setState(() {
                      _accounts = result;
                    });
                  }
                },
                child: Card(
                  color: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 40, color: Colors.green),
                        SizedBox(height: 8),
                        Text("새 계정 추가", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              );
            }

            final user = _accounts[index];
            return GestureDetector(
              onTap: () {
                _showPinDialog(user);
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(radius: 30, child: Icon(Icons.person)),
                    const SizedBox(height: 8),
                    Text(user.nickname, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
