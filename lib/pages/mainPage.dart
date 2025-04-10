import 'package:flutter/material.dart';
// import 'package:slivermate_project_flutter/vo/categoryVo.dart';
import 'package:video_player/video_player.dart';
// import 'package:slivermate_project_flutter/pages/categoryPage.dart'; // 카테고리 페이지 임포트
import 'package:slivermate_project_flutter/widgets/LoadingOverlay.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'dart:async';

class MainPage extends StatefulWidget {
  final UserVo? dummyUser;
  // final UserVo? userVo;
  // final CategoryVo? categoryVo;
  const MainPage({
    super.key,
    required this.dummyUser,
    // required this.userVo,
    // required this.categoryVo,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late VideoPlayerController _controller;
  bool isLoading = false; //  로딩 상태 변수 추가
  bool isDebugMode = true; //  디버그 모드 추가 (true: 이미지, false: 영상)
  bool isTextVisible = true; //  "터치해주세요" 애니메이션 상태 변수

  @override
  void initState() {
    super.initState();
    if (!isDebugMode) {
      _initializeVideo();
    }
    _startTextAnimation(); //  "터치해주세요" 애니메이션 시작

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(
        "[MainPage] dummyUser 확인: ${widget.dummyUser?.userName}, ${widget.dummyUser?.email}",
        // "[MainPage] userVo 확인: \${widget.userVo?.userName}, \${widget.userVo?.email}",
      );
    });
  }

  ///  "터치해주세요" 텍스트 깜빡이는 애니메이션
  void _startTextAnimation() {
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (mounted) {
        setState(() {
          isTextVisible = !isTextVisible;
        });
      }
    });
  }

  ///  비디오 초기화 (디버그 모드가 아닐 때만 실행)
  void _initializeVideo() {
    _controller = VideoPlayerController.asset("lib/images/skan09.mp4")
      ..initialize()
          .then((_) {
            if (mounted) {
              setState(() {});
              _controller.setLooping(true);
              _controller.play();
            }
          })
          .catchError((e) {
            print("비디오 로드 오류: $e");
          });
  }

  //  클릭 시 로그인 여부에 따라 다른 페이지로 이동
  void _onBackgroundTap() {
    if (!isDebugMode) {
      _controller.dispose(); //  비디오 컨트롤러 해제
    }
    print('[DEBUG] 터치됨');
    print('[DEBUG] 현재 로그인 상태: ${widget.dummyUser == null ? '로그인 안됨' : '로그인됨'}');

    if (widget.dummyUser == null) {
      print('[DEBUG] /loginPage 페이지로 이동');
      Navigator.of(context).pushNamed('/loginPage');
    } else {
      print(
        '[DEBUG] /selectAccountPage 페이지로 이동 - 전달 데이터: \${widget.dummyUser!.userName}',
      );
      Navigator.of(
        context,
      ).pushNamed('/selectAccountPage', arguments: [widget.dummyUser!]);
    }

    // if (widget.userVo == null) {
    //   Navigator.of(context).pushNamed('/login');
    // } else {
    //   Navigator.of(context).pushNamed('/signUpPage2', arguments: widget.userVo);
    // }

    _navigateToCategory(); //  부드러운 페이드 인/아웃 효과 적용
  }

  void _navigateToCategory() async {
    setState(() {
      isLoading = true; // ✅ 로딩 활성화
    });

    await Future.delayed(Duration(milliseconds: 500));

    // if (mounted) {
    //   await Navigator.of(context).push(
    //     PageRouteBuilder(
    //       pageBuilder:
    //           (context, animation, secondaryAnimation) => CategoryPage(
    //             dummyUser: widget.dummyUser, //  UserVo는 그대로 전달
    //           ),
    //       settings: RouteSettings(
    //         arguments: {
    //           "categoryVo": widget.categoryVo, //  CategoryVo를 arguments로 전달
    //         },
    //       ),
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         return FadeTransition(opacity: animation, child: child);
    //       },
    //       transitionDuration: Duration(milliseconds: 500),
    //     ),
    //   );
    //
    //   if (mounted) {
    //     setState(() {
    //       isLoading = false; //  로딩 종료
    //     });
    //   }
    // }
  }

  @override
  void dispose() {
    if (!isDebugMode && mounted) {
      _controller.dispose(); //  mounted 확인 후 dispose()
    }
    super.dispose();
  }

  // 회원가입 버튼 클릭 시 동작
  void _onSignUpPressed() {
    print('회원가입 버튼 클릭됨');
    Navigator.of(context).pushNamed('/signUpPage');
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading, //  로딩 중일 때 오버레이 표시
      child: Scaffold(
        body: GestureDetector(
          onTap: _onBackgroundTap, //
          child: Stack(
            children: [
              /// 🎥 배경 영상 or 디버그 모드 이미지
              Positioned.fill(
                child:
                    isLoading
                        ? Container(color: Colors.black) //  로딩 중엔 검은 화면 유지
                        : isDebugMode
                        ? Image.asset(
                          "lib/images/tree.png", //  디버그 모드일 경우 정지된 이미지 표시
                          fit: BoxFit.cover,
                        )
                        : _controller.value.isInitialized
                        ? FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        )
                        : Container(color: Colors.black), //  초기 로딩 중 검은 화면
              ),

              ///  **"터치해주세요" 폰트 추가 (배경 유지 + 중앙 배치 + 부드럽게 깜빡임)**
              Positioned.fill(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///  '파'를 왼쪽 위로 이동
                          Transform.translate(
                            offset: Offset(-10, -10), // 왼쪽 위로 이동
                            child: const Text(
                              '파',
                              style: TextStyle(
                                fontFamily: 'KCCHyerim',
                                fontSize: 120,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 6.0,
                                shadows: [
                                  Shadow(
                                    offset: Offset(-5, -5),
                                    blurRadius: 12,
                                    color: Color(0xFF9FD542),
                                  ),
                                  Shadow(
                                    offset: Offset(5, 5),
                                    blurRadius: 12,
                                    color: Color(0xFF5F8028),
                                  ),
                                  Shadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 30,
                                    color: Color(0xFF1D270C),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          ///  '릇'을 오른쪽 아래로 이동
                          Transform.translate(
                            offset: Offset(10, 10), // 오른쪽 아래로 이동
                            child: const Text(
                              '릇',
                              style: TextStyle(
                                fontFamily: 'KCCHyerim',
                                fontSize: 115,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 6.0,
                                shadows: [
                                  Shadow(
                                    offset: Offset(-5, -5),
                                    blurRadius: 12,
                                    color: Color(0xFF9FD542),
                                  ),
                                  Shadow(
                                    offset: Offset(5, 5),
                                    blurRadius: 12,
                                    color: Color(0xFF5F8028),
                                  ),
                                  Shadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 30,
                                    color: Color(0xFF1D270C),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const Text(
                      //   '파릇',
                      //   style: TextStyle(
                      //     fontFamily: 'KCCHyerim', //  새로운 폰트 적용
                      //     fontSize: 90,
                      //     color: Colors.white,
                      //     fontWeight: FontWeight.w600,
                      //     letterSpacing: 6.0,
                      //     shadows: [
                      //       Shadow(
                      //         offset: Offset(-5, -5),
                      //         blurRadius: 12,
                      //         color: Color(0xFF84B448),
                      //       ),
                      //       Shadow(
                      //         offset: Offset(5, 5),
                      //         blurRadius: 12,
                      //         color: Color(0xFF84B448),
                      //       ),
                      //       Shadow(
                      //         offset: Offset(0, 0),
                      //         blurRadius: 30,
                      //         color: Color(0xFF84B448),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      AnimatedOpacity(
                        opacity: isTextVisible ? 1.0 : 0.6,
                        duration: const Duration(milliseconds: 800),
                        child: const Text(
                          "터치해주세요",
                          style: TextStyle(
                            fontFamily: 'GowunDodum',
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4.0,
                            shadows: [
                              Shadow(
                                offset: Offset(-5, -5),
                                blurRadius: 12,
                                color: Color(0xFF576D23),
                              ),
                              Shadow(
                                offset: Offset(5, -5),
                                blurRadius: 12,
                                color: Color(0xFF576D23),
                              ),
                              Shadow(
                                offset: Offset(-5, 5),
                                blurRadius: 12,
                                color: Color(0xFF576D23),
                              ),
                              Shadow(
                                offset: Offset(5, 5),
                                blurRadius: 12,
                                color: Color(0xFF576D23),
                              ),
                              Shadow(
                                offset: Offset(0, 0),
                                blurRadius: 20,
                                color: Color(0xFF576D23),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //  회원가입 버튼 추카
                      const SizedBox(height: 300),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //  회원가입 버튼
                          TextButton(
                            onPressed: _onSignUpPressed,
                            style: TextButton.styleFrom(
                              side: BorderSide.none, // 테두리 제거
                              backgroundColor: Colors.transparent,
                            ),
                            child: const Text(
                              "회원가입",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.lightGreen,
                                fontSize: 30,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 7,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class MainPage extends StatelessWidget {
//   const MainPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("메인페이지"),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: Container(color: Colors.grey[100], child: _MainPage()),
//     );
//   }
// }
//
// class _MainPage extends StatefulWidget {
//   const _MainPage({super.key});
//
//   @override
//   State<_MainPage> createState() => _MainPageState();
// }
//
// class _MainPageState extends State<_MainPage> {
//   bool isDebugMode = false; //  디버그 모드 상태
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Form(
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, "/category");
//                 },
//                 child: Text("카데고리 화면으로 이동"),
//               ),
//             ),
//             SizedBox(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, "/introduce");
//                 },
//                 child: Text("인트로 화면으로 이동"),
//               ),
//             ),
//             SizedBox(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, "/purchase");
//                 },
//                 child: Text("결제 화면으로 이동"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
