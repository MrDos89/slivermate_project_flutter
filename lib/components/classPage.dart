import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/clubVo.dart';

class ClassPage extends StatelessWidget {
  final ClubVo club;
  const ClassPage({Key? key, required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        // 상단 헤더 적용
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: HeaderPage(pageTitle: "내가 가입한 모임"),
        ),
        body: Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 모임 썸네일: 데이터가 있으면 네트워크 이미지, 없으면 회색 박스와 안내문
                    club.clubThumbnail.isNotEmpty
                        ? Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(club.clubThumbnail),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                        : Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                          child: const Center(
                            child: Text(
                              "모임 썸네일 없음",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                    const SizedBox(height: 16),
                    // 모임 이름
                    Text(
                      club.clubName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 모임 설명
                    Text(club.clubDesc, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    // 모임 멤버 수 표시
                    Row(
                      children: [
                        const Icon(Icons.people, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "멤버: ${club.clubMemberNumber} / ${club.clubMemberMax}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // 가입 일자 표시 (날짜 포맷: YYYY-MM-DD)
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "가입일: ${club.clubRegisterDate.year}-${club.clubRegisterDate.month.toString().padLeft(2, '0')}-${club.clubRegisterDate.day.toString().padLeft(2, '0')}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // 신고 횟수
                    Text(
                      "신고 횟수: ${club.clubReportCnt}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
