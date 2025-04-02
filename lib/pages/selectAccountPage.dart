import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:slivermate_project_flutter/pages/signUpPage2.dart';

class SelectAccountPage extends StatefulWidget {
  final List<UserVo> userList;

  const SelectAccountPage({super.key, required this.userList});

  @override
  State<SelectAccountPage> createState() => _SelectAccountPageState();
}


class _SelectAccountPageState extends State<SelectAccountPage> {
  late List<UserVo> _accounts;


  @override
  void initState() {
    super.initState();
    _accounts = widget.userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('계정 선택')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: _accounts.length < 4 ? _accounts.length + 1 : _accounts.length,
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

                  // 새로 추가된 계정이 있다면 갱신
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
                Navigator.pushNamed(
                  context,
                  '/config',
                  arguments: user,
                );
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
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


  // [yj] '준비중입니다' 함수
  // void _showComingSoonDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder:
  //         (context) =>
  //         AlertDialog(
  //           title: const Text("준비중"),
  //           content: const Text("해당 기능은 아직 준비중입니다."),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text("확인"),
  //             ),
  //           ],
  //         ),
  //   );
  // }




