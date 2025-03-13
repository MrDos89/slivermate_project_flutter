import 'package:flutter/material.dart';

class CallStaffPage extends StatefulWidget {
  const CallStaffPage({super.key});

  @override
  _CallStaffPageState createState() => _CallStaffPageState();
}

class _CallStaffPageState extends State<CallStaffPage> {
  bool isCalling = false; // 직원 호출 상태
  String? selectedReason; // 선택한 호출 사유
  final TextEditingController _detailsController =
      TextEditingController(); // 추가 요청 사항

  // 호출 사유 목록
  final List<String> callReasons = ["기능 오류", "추천 요청", "결제 문제", "기타 문의"];

  void _callStaff() {
    if (selectedReason == null) return; // 🔥 호출 사유 선택해야 실행

    setState(() {
      isCalling = true;
    });

    // 직원 호출 요청 후 3초 후 완료 모달 띄우기
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context); // 기존 모달 닫기
        _showCompletedModal(); // ✅ 새 모달 띄우기
      }
    });
  }

  // 📌 호출 완료 모달
  void _showCompletedModal() {
    showDialog(
      context: context,
      barrierDismissible: false, // ❌ 바깥 클릭으로 닫히지 않도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("호출 완료"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                "직원 호출이 완료되었습니다.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // 닫기 버튼
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("직원 호출"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                isCalling ? Icons.person_pin_circle : Icons.person_search,
                size: 150,
                color: isCalling ? Colors.red : Colors.lightBlueAccent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "호출 사유를 선택하세요:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedReason,
              items:
                  callReasons.map((reason) {
                    return DropdownMenuItem(value: reason, child: Text(reason));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedReason = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "선택하세요",
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "추가 요청 사항 (선택 사항):",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _detailsController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "추가 요청 사항을 입력하세요...",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // 닫기 버튼
          child: const Text("닫기"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                (selectedReason == null || isCalling)
                    ? Colors.grey
                    : Colors.deepPurple,
            foregroundColor:
                (selectedReason == null || isCalling)
                    ? Colors.black
                    : Colors.white, // ✅ 활성화 시 흰색, 비활성화 시 검은색
          ),
          onPressed: (selectedReason == null || isCalling) ? null : _callStaff,
          child: Text(isCalling ? "호출 중..." : "직원 호출"),
        ),
      ],
    );
  }
}
