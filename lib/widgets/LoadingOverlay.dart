import 'package:flutter/material.dart';

///  **로딩 오버레이 (화면 위에 덮어씌우기)**
class LoadingOverlay extends StatelessWidget {
  final bool isLoading; //  로딩 중 여부
  final Widget child; // 기존 화면

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, //  기존 화면
        if (isLoading)
          Positioned.fill(
            //  화면 전체 덮기
            child: AbsorbPointer(
              //  로딩 중 터치 방지
              child: Container(
                color: Color(0xFFD6FFDC).withOpacity(0.9), // 반투명 배경
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF077A00), //  로딩 아이콘 색상 변경
                        ),
                      ),
                      SizedBox(height: 20),
                      // Text(
                      //   "버퍼링 중...",
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //     color: Color(0xFF077A00),
                      //     decoration: TextDecoration.none,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
