import 'package:flutter/material.dart';

class AddAnnounceForm extends StatefulWidget {
  final DateTime selectedDate;

  const AddAnnounceForm({super.key, required this.selectedDate});

  @override
  State<AddAnnounceForm> createState() => _AddAnnounceFormState();
}

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