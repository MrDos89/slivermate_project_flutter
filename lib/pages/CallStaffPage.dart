import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';
import 'package:slivermate_project_flutter/vo/SliverVo.dart';

class CallStaffPage extends StatefulWidget {
  final UserVo? dummyUser;
  const CallStaffPage({super.key, required this.dummyUser});

  @override
  _CallStaffPageState createState() => _CallStaffPageState();
}

class _CallStaffPageState extends State<CallStaffPage> {
  bool isCalling = false; // 직원 호출 상태
  int? selectedReasonId; // 선택한 호출 사유 (int 값)
  final TextEditingController _detailsController =
      TextEditingController(); // 추가 요청 사항

  //  호출 사유 목록 (문자열 → int 매핑)
  final Map<String, int> callReasons = {
    "기능 오류": 1,
    "추천 요청": 2,
    "결제 문제": 3,
    "기타 문의": 4,
  };

  /// 직원 호출 요청 (API 전송)
  void _callStaff() async {
    if (selectedReasonId == null) return; //  호출 사유 선택해야 실행됨

    setState(() {
      isCalling = true;
    });

    // 신고 데이터 생성
    SliverVo report = SliverVo(
      userId: 1, // TODO: 실제 로그인한 유저 ID로 변경
      lessonId: 100, // TODO: 신고 대상 ID로 변경
      reportId: selectedReasonId!,
      reportContent: _detailsController.text.trim(), // 신고 내용 추가
      isConfirmed: false,
      updDate: DateTime.now(),
    );

    // 서버로 데이터 전송
    bool success = await SliverVo.sendReport(report);

    // 호출 완료 모달을 2초 후에 띄우도록
    Future.delayed(const Duration(seconds: 2), () {
      //  2초 후 실행
      if (mounted) {
        Navigator.pop(context); // 기존 모달 닫기
        if (success) {
          _showCompletedModal(); // 성공 모달
        } else {
          _showErrorModal(); // 실패 모달
        }
      }
    });
  }

  /// 호출 완료 모달
  void _showCompletedModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("호출 완료"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, size: 80, color: Colors.green),
              SizedBox(height: 20),
              Text(
                "직원 호출이 완료되었습니다.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  /// 호출 실패 모달
  void _showErrorModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("호출 실패"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.error_outline, size: 80, color: Colors.red),
              SizedBox(height: 20),
              Text(
                "직원 호출에 실패했습니다. 다시 시도해주세요.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
            DropdownButtonFormField<int>(
              value: selectedReasonId,
              items:
                  callReasons.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.value,
                      child: Text(entry.key),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedReasonId = value;
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
                hintText: "추가 요청 사항을 입력하세요(최대 100자)",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("닫기"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                (selectedReasonId == null || isCalling)
                    ? Colors.grey
                    : Colors.deepPurple,
            foregroundColor:
                (selectedReasonId == null || isCalling)
                    ? Colors.black
                    : Colors.white,
          ),
          onPressed:
              (selectedReasonId == null || isCalling) ? null : _callStaff,
          child: Text(isCalling ? "호출 중..." : "직원 호출"),
        ),
      ],
    );
  }
}
