import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          children: [
            _buildNotificationBubble("📌 동산 동아리에 가입되었습니다"),
            const SizedBox(height: 15),
            _buildNotificationBubble("💰 결제가 완료되었습니다"),
            const SizedBox(height: 15),
            _buildNotificationBubble(
              "⏳ <청춘은바로지금> 동아리 정기 모임 날짜(8/20)까지 5일 남았습니다",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationBubble(String message) {
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
