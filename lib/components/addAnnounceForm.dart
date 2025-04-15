import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:slivermate_project_flutter/vo/announceVo.dart';
import 'package:intl/intl.dart';

class AddAnnounceForm extends StatefulWidget {
  final DateTime selectedDate;

  const AddAnnounceForm({super.key, required this.selectedDate});

  @override
  State<AddAnnounceForm> createState() => _AddAnnounceFormState();
}

final Dio dio = Dio(BaseOptions(
  baseUrl: 'http://43.201.50.194:18090/api',
  contentType: 'application/json',
));

class _AddAnnounceFormState extends State<AddAnnounceForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 내용을 모두 입력해주세요')),
      );
      return;
    }

    // 등록 처리 로직
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('공지 등록 완료')),
    );

    void _handleSubmit() async {
      final title = _titleController.text.trim();
      final content = _contentController.text.trim();

      if (title.isEmpty || content.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('제목과 내용을 모두 입력해주세요')),
        );
        return;
      }

      // 🔽 서버에 보낼 VO 구성
      final newAnnouncement = AnnounceVo(
        title: title,
        date: DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(widget.selectedDate),
        time: '오전 10시', // 기본값 혹은 다른 입력 받아도 됨
        location: '온라인', // 필요 시 입력 필드 추가 가능
        description: content,
        memberList: [], // 모임인 경우에만 쓰임, 지금은 공지니까 빈 배열
        meetingPrice: '',
        attendingCount: 0,
        type: 1, // 공지: 1
        updDate: DateTime.now(),
      );

      try {
        final response = await dio.post(
          '/announcement',
          data: newAnnouncement.toJson(),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('공지 등록 완료')),
          );
          Navigator.pop(context); // 이전 화면으로
        } else {
          throw Exception("서버 오류: ${response.statusCode}");
        }
      } catch (e) {
        print("❌ 오류 발생: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('등록 실패: 네트워크 오류')),
        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('공지 제목'),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '제목을 입력하세요',
          ),
        ),
        const SizedBox(height: 16),
        const Text('내용'),
        const SizedBox(height: 8),
        TextField(
          controller: _contentController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '공지 내용을 입력하세요',
          ),
          maxLines: 5,
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF229F3B),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              '추가하기',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}