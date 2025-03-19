import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';

class NotificationPage extends StatelessWidget {
  final UserVo? dummyUser;
  const NotificationPage({super.key, required this.dummyUser});

  @override
  Widget build(BuildContext context) {
    List<String> notifications = [
      "📌 동산 동아리에 가입되었습니다",
      "💰 결제가 완료되었습니다",
      "⏳ <청춘은바로지금> 동아리 정기 모임 날짜(8/20)까지 5일 남았습니다",
    ];

    return MainLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("실시간 알림"),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              notifications.length,
              (index) => Column(
                children: [
                  _buildNotificationBubble(
                    notifications[index],
                    index == notifications.length - 1, // 가장 최신 알림에만 애니메이션 적용
                  ),
                  if (index != notifications.length - 1)
                    const SizedBox(height: 15), // 간격 유지
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 최신 알람일 경우 Fade In + Scale + 반짝임 애니메이션 적용
  Widget _buildNotificationBubble(String message, bool isLatest) {
    return isLatest
        ? _buildAnimatedNotification(message) // ✅ 최신 알람만 애니메이션 적용
        : _buildStaticNotification(message);
  }

  /// 🎨 기본 알림 (애니메이션 없음)
  Widget _buildStaticNotification(String message) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20), // 말풍선 위치 조정
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFE6D5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 10,
          child: CustomPaint(
            painter: BubbleTailPainter(), // ⬅️ 말풍선 꼬리 추가
          ),
        ),
      ],
    );
  }
}

/// 🚀 최신 알림 애니메이션 (Fade In + Scale + 반짝임)
Widget _buildAnimatedNotification(String message) {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 800),
    builder: (context, double value, child) {
      return Opacity(
        opacity: value,
        child: Transform.scale(
          scale: 0.9 + (0.1 * value), // ✅ Scale Animation (0.9~1.0)
          child: child,
        ),
      );
    },
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE6D5FF),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  // color: Colors.purpleAccent.withOpacity(0.3),
                  // blurRadius: 10,
                  // spreadRadius: 1,
                ),
              ],
            ),
            child: _buildShiningText(message), // 🔥 반짝이는 텍스트
          ),
        ),
        Positioned(
          left: 10,
          top: 10,
          child: CustomPaint(painter: BubbleTailPainter()),
        ),
      ],
    ),
  );
}

/// ✨ 반짝반짝 효과 (Fade In / Out)
Widget _buildShiningText(String message) {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 0.6, end: 1.0),
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    builder: (context, double opacity, child) {
      return Opacity(opacity: opacity, child: child);
    },
    onEnd: () {}, // 애니메이션 끝나도 유지
    child: Text(
      message,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    ),
  );
}

// 🎨 말풍선 꼬리 그리는 클래스
class BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Color(0xFFE6D5FF)!
          ..style = PaintingStyle.fill;

    // 삼각형(꼬리) 경로 생성
    final path =
        Path()
          ..moveTo(10, 0)
          ..lineTo(0, 10)
          ..lineTo(20, 10)
          ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
