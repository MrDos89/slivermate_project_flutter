import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/lessonVo.dart';

class LessonPage extends StatelessWidget {
  final LessonVo lesson;
  const LessonPage({Key? key, required this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "내 강의"),
        ),
        body: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 강의 썸네일 (더미 데이터의 경우 빈 문자열이면 회색 박스 처리)
                  lesson.lessonThumbnail.isNotEmpty
                      ? Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(lesson.lessonThumbnail),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                      : Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "썸네일 없음",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                  const SizedBox(height: 16),
                  Text(
                    lesson.lessonName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(lesson.lessonDesc, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        lesson.registerDate,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.thumb_up, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${lesson.likeCount}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.visibility, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${lesson.viewCount}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "가격: ${lesson.lessonPrice == 0 ? "무료" : lesson.lessonPrice.toString()}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "설명: ${lesson.lessonCostDesc}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  // 필요에 따라 추가 정보를 여기에 배치할 수 있습니다.
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
