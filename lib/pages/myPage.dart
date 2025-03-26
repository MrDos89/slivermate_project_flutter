// import 'package:flutter/material.dart';
//
// /// "마이페이지" 중앙 바디만 따로 구성한 위젯
// class MyPageBody extends StatelessWidget {
//   const MyPageBody({Key? key}) : super(key: key);
//
//   /// "준비중입니다" 안내창 띄우는 함수
//   void _showComingSoonDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("준비중입니다"),
//           content: const Text("해당 기능은 현재 준비중입니다."),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("확인"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // 첫 번째 그림(스케치)에 나온 박스(버튼)들을 예시로 작성
//     // 원하시는대로 항목 수정 가능
//     final List<String> items = [
//       "실내활동",
//       "낚시",
//       "요양원",
//       "구독상태: 0원",
//       "구독기간: 23.8.20~23.9.20",
//       "계정등급",
//       "회원정보",
//       "정원",
//       "모임",
//       "음악",
//       "내글보기",
//       "내댓글보기",
//       "내찜목록",
//       "오유원장",
//     ];
//
//     return Scaffold(
//       // 앱바나 푸터는 따로 관리한다고 했으므로 여기서는 생략
//       // 전체 배경만 그라디언트로 설정
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFFE9F9E9), // 연한 연두색
//               Color(0xFFD2F0D2), // 조금 더 진한 연두색
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//             child: Column(
//               children: [
//                 // 원하는 상단 제목이나 여백을 추가할 수 있습니다
//                 // Text(
//                 //   '마이페이지',
//                 //   style: TextStyle(
//                 //     fontSize: 24,
//                 //     fontWeight: FontWeight.bold,
//                 //     color: Colors.green,
//                 //   ),
//                 // ),
//
//                 // GridView로 2열 버튼 배치
//                 GridView.builder(
//                   // GridView가 Column 안에 들어가므로
//                   // 높이 충돌을 막기 위해 아래 두 설정 필요
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//
//                   itemCount: items.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2, // 2열
//                     mainAxisSpacing: 10, // 세로 간격
//                     crossAxisSpacing: 10, // 가로 간격
//                     childAspectRatio: 2.0, // 버튼 가로:세로 비율 (조절 가능)
//                   ),
//                   itemBuilder: (context, index) {
//                     return ElevatedButton(
//                       onPressed: () => _showComingSoonDialog(context),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF229F3B), // 초록색
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         textStyle: const TextStyle(
//                           fontFamily: 'GowunDodum',
//                           fontSize: 16,
//                         ),
//                       ),
//                       child: Text(
//                         items[index],
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
