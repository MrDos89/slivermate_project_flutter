import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';
import 'package:slivermate_project_flutter/pages/paymentPage.dart';

/// 결제 리스트에 표시할 더미 모델 (예: 모임 정보)
class PaymentItem {
  final String thumbnailUrl;
  final String meetingName;
  final String meetingDesc;
  final String meetingLocationTime; // 예: "한강 / 19:00"
  final int meetingFee; // 예: 10000
  final bool isPaid; // 결제 완료 여부
  final DateTime dateJoined; // 참석 버튼을 누른 시점
  final DateTime? paidAt; // 결제 완료 시점 (null이면 결제 전)

  PaymentItem({
    required this.thumbnailUrl,
    required this.meetingName,
    required this.meetingDesc,
    required this.meetingLocationTime,
    required this.meetingFee,
    required this.isPaid,
    required this.dateJoined,
    this.paidAt,
  });
}

class PaymentListPage extends StatefulWidget {
  const PaymentListPage({Key? key}) : super(key: key);

  @override
  State<PaymentListPage> createState() => _PaymentListPageState();
}

class _PaymentListPageState extends State<PaymentListPage> {
  /// 더미데이터: 실제로는 서버(백엔드)에서 받아온 데이터를 사용
  final List<PaymentItem> _paymentItems = [
    PaymentItem(
      thumbnailUrl:
          "https://image.shutterstock.com/image-photo/group-people-running-260nw-463291649.jpg",
      meetingName: "한강 야간 러닝",
      meetingDesc: "한강에서 함께 달려봐요! 초보 환영",
      meetingLocationTime: "한강 반포 / 19:00",
      meetingFee: 5000,
      isPaid: false,
      dateJoined: DateTime(2025, 4, 1),
      paidAt: null,
    ),
    PaymentItem(
      thumbnailUrl:
          "https://image.shutterstock.com/image-photo/mountain-hikers-260nw-368237157.jpg",
      meetingName: "청계산 등산 모임",
      meetingDesc: "초보 등산러도 완등 가능, 함께가요!",
      meetingLocationTime: "청계산 입구 / 08:00",
      meetingFee: 10000,
      isPaid: true,
      dateJoined: DateTime(2025, 3, 30),
      paidAt: DateTime(2025, 3, 31, 14, 20),
    ),
    PaymentItem(
      thumbnailUrl:
          "https://image.shutterstock.com/image-photo/music-concert-party-lights-260nw-140238709.jpg",
      meetingName: "라이브 콘서트 관람",
      meetingDesc: "음악 좋아하는 사람 모여!",
      meetingLocationTime: "홍대 공연장 / 20:00",
      meetingFee: 30000,
      isPaid: false,
      dateJoined: DateTime(2025, 4, 2),
      paidAt: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: const HeaderPage(pageTitle: "결제 목록", showBackButton: true),
        body: ListView.builder(
          itemCount: _paymentItems.length,
          itemBuilder: (context, index) {
            final item = _paymentItems[index];
            return _buildPaymentItemCard(item);
          },
        ),
      ),
    );
  }

  /// 각 모임(결제 아이템)을 표시하는 Card
  Widget _buildPaymentItemCard(PaymentItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            /// 왼쪽 썸네일
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.thumbnailUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder:
                    (ctx, err, stack) =>
                        Container(width: 80, height: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),

            /// 오른쪽 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.meetingName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.meetingDesc,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.meetingLocationTime,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "회비: ${item.meetingFee}원",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  if (item.isPaid)
                    // 결제 완료
                    Text(
                      "결제 완료 (${_formattedDate(item.paidAt)})",
                      style: const TextStyle(fontSize: 13, color: Colors.green),
                    )
                  else
                    // 결제 전
                    Text(
                      "참석일: ${_formattedDate(item.dateJoined)} (결제 필요)",
                      style: const TextStyle(fontSize: 13, color: Colors.red),
                    ),
                ],
              ),
            ),
            if (!item.isPaid) ...[
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  /// 결제하기 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => PaymentPage(
                            meetingTitle: item.meetingName,
                            meetingDesc: item.meetingDesc,
                            meetingFee: item.meetingFee,
                            meetingTime: item.meetingLocationTime,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("결제하기"),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 포매팅 함수 (DateTime → yyyy-MM-dd)
  String _formattedDate(DateTime? dateTime) {
    if (dateTime == null) return "";
    return "${dateTime.year}-${_padZero(dateTime.month)}-${_padZero(dateTime.day)}";
  }

  String _padZero(int value) => value.toString().padLeft(2, '0');
}
