import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/components/addAnnounceForm.dart';
import 'package:slivermate_project_flutter/components/addMeetingForm.dart';
import 'package:slivermate_project_flutter/vo/announceVo.dart';

class AddMeetingPage extends StatefulWidget {
  final DateTime selectedDate;
  final AnnounceVo? existingSchedule;

  const AddMeetingPage({super.key, required this.selectedDate, this.existingSchedule,});

  @override
  State<AddMeetingPage> createState() => _AddMeetingPageState();
}


class _AddMeetingPageState extends State<AddMeetingPage> {
  int selectedType = 2; // 1: 공지, 2: 모임
  final TextEditingController _feeController = TextEditingController();

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
                selectedType == 1
                    ? AddAnnounceForm(selectedDate: widget.selectedDate)
                    : AddMeetingForm(selectedDate: widget.selectedDate),
              ],
            ),
          ),
        ),
      ),
    );
  }
}