import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/pages/notificationPage.dart';

class HeaderPage extends StatefulWidget implements PreferredSizeWidget {
  /// 페이지 타이틀 (예: "채팅", "게시글", "레슨", "동아리" 등)
  final String pageTitle;

  /// 뒤로가기 버튼 표시 여부
  final bool showBackButton;

  // [yj] 알람페이지 여부 확인
  final bool isNotificationPage;
  final bool isEditing;
  final ValueChanged<bool>? onEditingChanged;
  final VoidCallback? onDeleteSelected;
  final VoidCallback? onDeleteAll;

  const HeaderPage({Key? key, this.pageTitle = '', this.showBackButton = false,
    this.isNotificationPage = false, this.isEditing = false, this.onEditingChanged,
    this.onDeleteSelected, this.onDeleteAll,})
    : super(key: key);

  @override
  _HeaderPageState createState() => _HeaderPageState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _HeaderPageState extends State<HeaderPage> {
  bool isEditing = false;  // 편집 모드 여부

  void _toggleEditingMode() {
    if (widget.onEditingChanged != null) {
      widget.onEditingChanged!(!widget.isEditing);
    }
  }

  @override
  void didUpdateWidget(covariant HeaderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEditing != isEditing) {
      setState(() {
        isEditing = widget.isEditing;
      });
    }
  }


  // "준비중" 팝업 다이얼로그
  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("준비중"),
            content: const Text("해당 기능은 아직 준비중입니다."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("확인"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: const Color(0xFF044E00).withAlpha(128),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFFFFFFFF),
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                tooltip: "뒤로가기",
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  widget.pageTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (widget.isNotificationPage)
                if (!isEditing)
                  TextButton(
                    onPressed: _toggleEditingMode,
                    child: const Text(
                      "편집",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          widget.onDeleteSelected?.call();
                          _toggleEditingMode();
                        },
                        child: const Text(
                          "일부 삭제",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.onDeleteAll?.call();
                          _toggleEditingMode();
                        },
                        child: const Text(
                          "전체 삭제",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _toggleEditingMode,
                        child: const Text(
                          "취소",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
              if (!widget.isNotificationPage)
                Row(
                  children: [
                    // 알람 아이콘
                    IconButton(
                      icon: const Icon(
                        Icons.notifications,
                        color: Color(0xFFFFFFFF),
                        size: 30,
                      ),
                      onPressed: () => _showComingSoonDialog(context),
                      tooltip: "알람",
                    ),
                    // 설정 아이콘
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: Color(0xFFFFFFFF),
                        size: 30,
                      ),
                      onPressed: () => _showComingSoonDialog(context),
                      tooltip: "설정",
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// class EditActions extends StatelessWidget {
//   final VoidCallback onCancel;
//   final VoidCallback onDeleteSelected;
//   final VoidCallback onDeleteAll;
//
//   const EditActions({
//     Key? key,
//     required this.onCancel,
//     required this.onDeleteSelected,
//     required this.onDeleteAll,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         TextButton(
//           onPressed: onDeleteSelected,
//           child: const Text(
//             "일부 삭제",
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: Colors.deepPurple,
//             ),
//           ),
//         ),
//         TextButton(
//           onPressed: onDeleteAll,
//           child: const Text(
//             "전체 삭제",
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: Colors.red,
//             ),
//           ),
//         ),
//         TextButton(
//           onPressed: onCancel,
//           child: const Text(
//             "취소",
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
