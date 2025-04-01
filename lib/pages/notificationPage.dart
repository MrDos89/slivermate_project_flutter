import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/vo/userVo.dart';

class NotificationPage extends StatefulWidget {
  final UserVo? dummyUser;
  final bool isEditing;
  const NotificationPage({super.key, required this.dummyUser, required this.isEditing});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late bool isEditing;
  List<bool> isSelected = [];
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    isEditing = widget.isEditing;

    notifications = [
      " 동산 동아리에 가입되었습니다",
      " 결제가 완료되었습니다",
      " <청춘은바로지금> 동아리 정기 모임 날짜(8/20)까지 5일 남았습니다",
    ];
    isSelected = List.generate(notifications.length, (_) => false);
  }

  void _deleteSelected() {
    setState(() {
      for (int i = isSelected.length - 1; i >= 0; i--) {
        if (isSelected[i]) {
          notifications.removeAt(i);
          isSelected.removeAt(i);
        }
      }
      // 모두 삭제되었으면 편집모드 자동 해제
      if (notifications.isEmpty) isEditing = false;
    });
  }

  void _deleteAll() {
    setState(() {
      notifications.clear();
      isSelected.clear();
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<String> notifications = [
    //   " 동산 동아리에 가입되었습니다",
    //   " 결제가 완료되었습니다",
    //   " <청춘은바로지금> 동아리 정기 모임 날짜(8/20)까지 5일 남았습니다",
    // ];
    return MainLayout(
      dummyUser: widget.dummyUser,
      child: Scaffold(
        appBar: HeaderPage(
          pageTitle: "알람 페이지",
          isNotificationPage: true,
          isEditing: isEditing, // 현재 편집 상태 전달
          onEditingChanged: (bool newEditingState) {
            setState(() {
              isEditing = newEditingState;
            });
          },
          onDeleteSelected: _deleteSelected,
          onDeleteAll: _deleteAll,
        ),
        body:
        notifications.isEmpty
            ? Center(child: Text("알림이 없습니다."))
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              notifications.length,
                  (index) => Column(
                children: [
                  GestureDetector(
                    onTap:
                    isEditing
                        ? () {
                      setState(() {
                        isSelected[index] = !isSelected[index];
                      });
                    }
                        : null, // 편집 모드일 때만 반응
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isEditing)
                          Checkbox(
                            value:
                            index < isSelected.length
                                ? isSelected[index]
                                : false,
                            onChanged: (value) {
                              setState(() {
                                isSelected[index] = value ?? false;
                              });
                            },
                          ),
                        Expanded(
                          child: _buildNotificationBubble(
                            notifications[index],
                            index == notifications.length - 1 &&
                                !isEditing,
                            isSelected[index], // ← 체크 여부 전달
                          ),
                        ),
                        if (isEditing)
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                notifications.removeAt(index);
                                isSelected.removeAt(index);
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  if (index != notifications.length - 1)
                    const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // appBar: AppBar(
  // title: const Text("알림"),
  // backgroundColor: Colors.white,
  // elevation: 0,
  // leading: IconButton(
  // icon: const Icon(Icons.arrow_back, color: Colors.black),
  // onPressed: () {
  // Navigator.pop(context);
  // },
  // ),
  // actions: isEditing
  // ? [
  // Padding(
  // padding: const EdgeInsets.symmetric(vertical: 8),
  // child: Row(
  // mainAxisSize: MainAxisSize.min,
  // children: [
  // TextButton(
  // onPressed: _deleteSelected,
  // style: TextButton.styleFrom(
  // side: const BorderSide(color: Colors.deepPurple),
  // foregroundColor: Colors.deepPurple,
  // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  // // minimumSize: const Size(0, 30),
  // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  // visualDensity: VisualDensity.compact,
  // shape: RoundedRectangleBorder(
  // borderRadius: BorderRadius.circular(6),
  // ),
  // textStyle: const TextStyle(fontSize: 12),
  // ),
  // child: const Text("일부 삭제",
  // style: TextStyle(
  // fontSize: 12,
  // fontWeight: FontWeight.bold,
  // ),
  // ),
  // ),
  // const SizedBox(width: 6), // 간격 추가
  // TextButton(
  // onPressed: _deleteAll,
  // style: TextButton.styleFrom(
  // side: const BorderSide(color: Colors.red),
  // foregroundColor: Colors.red,
  // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  // // minimumSize: const Size(0, 30),
  // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  // visualDensity: VisualDensity.compact,
  // shape: RoundedRectangleBorder(
  // borderRadius: BorderRadius.circular(6),
  // ),
  // textStyle: const TextStyle(fontSize: 12),
  // ),
  // child: const Text("전체 삭제",
  // style: TextStyle(
  // fontSize: 12,
  // fontWeight: FontWeight.bold,
  // )
  // ),
  // ),
  // const SizedBox(width: 6), // 간격 추가
  // TextButton(
  // onPressed: () {
  // setState(() {
  // isEditing = false;
  // });
  // },
  // style: TextButton.styleFrom(
  // side: const BorderSide(color: Colors.grey),
  // foregroundColor: Colors.grey[700],
  // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  // // minimumSize: const Size(0, 30),
  // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  // visualDensity: VisualDensity.compact,
  // shape: RoundedRectangleBorder(
  // borderRadius: BorderRadius.circular(6),
  // ),
  // textStyle: const TextStyle(fontSize: 12),
  // ),
  // child: const Text("취소",
  // style: TextStyle(
  // fontSize: 12,
  // fontWeight: FontWeight.bold,
  // )
  // ),
  // ),
  // ],
  // ),
  // ),
  // ]
  //     : [
  // TextButton(
  // onPressed: () {
  // setState(() {
  // isEditing = true;
  // });
  // },
  // child: const Text("편집",
  // style: TextStyle(
  // fontSize: 12,
  // fontWeight: FontWeight.bold,
  // )
  // ),
  // ),
  // ],
  //
  // ),

  ///  최신 알람일 경우 Fade In + Scale + 반짝임 애니메이션 적용
  Widget _buildNotificationBubble(
      String message,
      bool isLatest,
      bool isChecked,
      ) {
    final backgroundColor =
    isChecked
        ? const Color(0xFF0F4A0D).withAlpha(128)
        : const Color(0xFF0BBC02).withAlpha(128);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black, // 텍스트 색은 그대로
        ),
      ),
    );
  }

  ///  기본 알림 (애니메이션 없음)
  Widget _buildStaticNotification(String message) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20), // 말풍선 위치 조정
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFE6D5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        // Positioned(
        //   left: 10,
        //   top: 10,
        //   child: CustomPaint(
        //     painter: BubbleTailPainter(), // ⬅️ 말풍선 꼬리 추가
        //   ),
        // ),
      ],
    );
  }
}

///  최신 알림 애니메이션 (Fade In + Scale + 반짝임)
Widget _buildAnimatedNotification(String message) {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 800),
    builder: (context, double value, child) {
      return Opacity(
        opacity: value,
        child: Transform.scale(
          scale: 0.9 + (0.1 * value), //  Scale Animation (0.9~1.0)
          child: child,
        ),
      );
    },
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE6D5FF),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  // color: Colors.purpleAccent.withOpacity(0.3),
                  // blurRadius: 10,
                  // spreadRadius: 1,
                ),
              ],
            ),
            child: _buildShiningText(message), //  반짝이는 텍스트
          ),
        ),
        // Positioned(
        //   left: 10,
        //   top: 10,
        //   child: CustomPaint(painter: BubbleTailPainter()),
        // ),
      ],
    ),
  );
}

///  반짝반짝 효과 (Fade In / Out)
Widget _buildShiningText(String message) {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 0.6, end: 1.0),
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    builder: (context, double opacity, child) {
      return Opacity(opacity: opacity, child: child);
    },
    onEnd: () {}, // 애니메이션 끝나도 유지
    child: Text(
      message,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    ),
  );
}

//  말풍선 꼬리 그리는 클래스
// class BubbleTailPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint =
//         Paint()
//           ..color = Color(0xFFE6D5FF)!
//           ..style = PaintingStyle.fill;
//
//     // 삼각형(꼬리) 경로 생성
//     final path =
//         Path()
//           ..moveTo(10, 0)
//           ..lineTo(0, 10)
//           ..lineTo(20, 10)
//           ..close();
//
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

Widget _buildNotificationBubble(String message) {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(left: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFE6D5FF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      message,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    ),
  );
}