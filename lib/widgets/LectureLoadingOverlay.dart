import 'package:flutter/material.dart';

/// ✅ **강의 페이지 이동 중 로딩 오버레이**
class LectureLoadingOverlay extends StatelessWidget {
  final bool isLoading; // 🔥 로딩 중 여부
  final Widget child; // 기존 화면

  const LectureLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // ✅ 기존 화면
        if (isLoading)
          Positioned.fill(
            child: AbsorbPointer(
              child: Container(
                color: Color(0xFFD6FFDC).withOpacity(0.9), // ✅ 배경색 반투명
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF077A00), // ✅ 로딩 아이콘 색상
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "강의 페이지로 이동 중입니다...",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF077A00),
                          decoration: TextDecoration.none,
                        ),
                      ),
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
