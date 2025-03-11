import 'package:flutter/material.dart';

class IntroducePage extends StatelessWidget {
  final String category;
  final String subCategory;
  final String lectureTitle;

  const IntroducePage({
    super.key,
    this.category = "실내",
    this.subCategory = "요가",
    this.lectureTitle = "기초 요가 스트레칭",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$category / $subCategory', // 대분류 / 소분류
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              lectureTitle, // 강의 제목
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(child: Text('강의 영상이 들어갈 자리')),
    );
  }
}
