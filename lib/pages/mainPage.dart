import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:slivermate_project_flutter/pages/categoryPage.dart'; // 카테고리 페이지 임포트
import 'package:slivermate_project_flutter/widgets/LoadingOverlay.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late VideoPlayerController _controller;
  bool isLoading = false; // ✅ 로딩 상태 변수 추가

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  /// 🎥 비디오 초기화 (단일 영상 유지)
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

  /// 🔹 배경 클릭 시 카테고리로 부드럽게 이동
  void _onBackgroundTap() {
    _controller.dispose(); // ✅ 비디오 컨트롤러 해제
    _navigateToCategory(); // ✅ 부드러운 페이드 인/아웃 효과 적용
  }

  void _navigateToCategory() async {
    setState(() {
      isLoading = true; // ✅ 로딩 활성화
    });

    // await Future.delayed(Duration(seconds: 1));
    await Future.delayed(Duration(milliseconds: 500));

    if (mounted) {
      await Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => CategoryPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );

      if (mounted) {
        setState(() {
          isLoading = false; // ✅ 로딩 종료
        });
      }
    }
  }

  @override
  void dispose() {
    if (mounted) {
      _controller.dispose(); // ✅ mounted 확인 후 dispose()
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading, // ✅ 로딩 중일 때 오버레이 표시
      child: Scaffold(
        body: GestureDetector(
          onTap: _onBackgroundTap, // 🔹 배경 클릭하면 카테고리로 이동
          child: Stack(
            children: [
              /// 🎥 배경 영상
              Positioned.fill(
                child:
                    isLoading
                        ? Container(color: Colors.black) // ✅ 로딩 중엔 검은 화면 유지
                        : _controller.value.isInitialized
                        ? FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        )
                        : Container(color: Colors.black), // ✅ 초기 로딩 중 검은 화면
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
//   bool isDebugMode = false; // 🔥 디버그 모드 상태
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
