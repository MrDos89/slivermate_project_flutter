import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';

class AddMeetingPage extends StatefulWidget {
  final DateTime selectedDate;

  const AddMeetingPage({super.key, required this.selectedDate});

  @override
  State<AddMeetingPage> createState() => _AddMeetingPageState();
}

class _AddMeetingPageState extends State<AddMeetingPage> {
  int selectedType = 1; // 1: 공지, 2: 모임

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: const HeaderPage(
          pageTitle: '일정 추가',
          showBackButton: true,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView( // 모바일 화면 작을 때 대비
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('일정 종류 선택'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('공지'),
                      selected: selectedType == 1,
                      onSelected: (_) {
                        setState(() => selectedType = 1);
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('모임'),
                      selected: selectedType == 2,
                      onSelected: (_) {
                        setState(() => selectedType = 2);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (selectedType == 1) _buildNoticeForm(),
                if (selectedType == 2) _buildMeetingForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoticeForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📌 공지 제목'),
        const SizedBox(height: 8),
        const TextField(decoration: InputDecoration(border: OutlineInputBorder())),
        const SizedBox(height: 16),
        const Text('🗓 날짜'),
        const SizedBox(height: 8),
        Text(
          "${widget.selectedDate.toLocal()}".split(' ')[0],
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildMeetingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('👥 모임 제목'),
        const SizedBox(height: 8),
        const TextField(decoration: InputDecoration(border: OutlineInputBorder())),
        const SizedBox(height: 16),
        const Text('📍 장소'),
        const SizedBox(height: 8),
        const TextField(decoration: InputDecoration(border: OutlineInputBorder())),
        const SizedBox(height: 16),
        const Text('💰 회비'),
        const SizedBox(height: 8),
        const TextField(decoration: InputDecoration(border: OutlineInputBorder())),
        const SizedBox(height: 16),
        const Text('🗓 날짜'),
        const SizedBox(height: 8),
        Text(
          "${widget.selectedDate.toLocal()}".split(' ')[0],
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
