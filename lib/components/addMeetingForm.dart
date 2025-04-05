import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:slivermate_project_flutter/vo/announceVo.dart';

class AddMeetingForm extends StatefulWidget {
  final DateTime selectedDate;
  final AnnounceVo? existingSchedule;

  const AddMeetingForm({super.key, required this.selectedDate, this.existingSchedule});

  @override
  State<AddMeetingForm> createState() => _AddMeetingFormState();
}
final List<int> hourOptions = List.generate(13, (i) => i);
final List<int> minuteOptions = [0, 10, 15, 30, 45]; // 원하는 분 단위만


class _AddMeetingFormState extends State<AddMeetingForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final NumberFormat _numberFormat = NumberFormat('#,###');
  int? _selectedHour;
  int? _selectedMinute;

  @override
  void initState() {
    super.initState();
    _feeController.addListener(_formatFee);
  }

  void _formatFee() {
    final raw = _feeController.text.replaceAll(',', '');
    if (raw.isEmpty) return;

    final number = int.tryParse(raw);
    if (number == null) return;

    final formatted = _numberFormat.format(number);
    if (_feeController.text != formatted) {
      _feeController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _handleSubmit() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final location = _locationController.text.trim();
    final fee = _feeController.text.trim();

    if (title.isEmpty || content.isEmpty || location.isEmpty || fee.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모임 제목, 내용, 장소, 회비를 모두 입력해주세요')),
      );
      return;
    }

    // 정상 등록 처리
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('모임 일정 등록 완료')),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _locationController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('모임 제목'),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '모임 제목을 입력하세요',
          ),
        ),
        const SizedBox(height: 16),
        const Text('내용'),
        const SizedBox(height: 8),
        TextField(
          controller: _contentController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '모임에 대한 내용을 입력하세요',
          ),
          maxLines: 5,
        ),
        const SizedBox(height: 16),
        const Text('장소'),
        const SizedBox(height: 8),
        TextField(
          controller: _locationController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '모임 장소를 입력하세요',
          ),
        ),
        const SizedBox(height: 16),
        const Text('회비'),
        const SizedBox(height: 8),
        TextField(
          controller: _feeController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            suffixText: '원',
            hintText: '숫자만 입력',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 날짜 텍스트
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('날짜'),
                const SizedBox(height: 8),
                Text(
                  "${widget.selectedDate.toLocal()}".split(' ')[0],
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(width: 24),

            // 시 드롭다운
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedHour,
                      hint: const Text(
                        '시간 선택',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      items: hourOptions.map((hour) {
                        return DropdownMenuItem(
                          value: hour,
                          child: Container(
                            height: 32,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${hour.toString().padLeft(2, '0')} 시',
                              style: const TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedHour = value;
                        });
                      },
                      isExpanded: true,
                      style: const TextStyle(fontSize: 20),
                      dropdownColor: Colors.white,

                      menuMaxHeight: 160,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),

            // 분 드롭다운
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedMinute,
                      hint: const Text(
                        '분 선택',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      items: minuteOptions.map((minute) {
                        return DropdownMenuItem(
                          value: minute,
                          child: Container(
                            height: 32, // 항목 높이
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${minute.toString().padLeft(2, '0')} 분',
                              style: const TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        print('[DEBUG] 선택된 분(minute): $val');
                        setState(() => _selectedMinute = val);
                      },
                      isExpanded: true,
                      style: const TextStyle(fontSize: 14),
                      dropdownColor: Colors.white,
                      menuMaxHeight: 160, // 항목 5개까지 보이고 스크롤
                    ),
                  )

                ],
              ),
            ),
          ],
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
