import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/components/headerPage.dart';
import 'package:slivermate_project_flutter/components/mainLayout.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

// 실내 + 실외 카테고리 원본 ID 유지
const Map<int, String> indoorHobbies = {
  0: "일상",
  1: "뜨개질",
  2: "그림",
  3: "독서",
  4: "영화 감상",
  5: "퍼즐",
  6: "요리",
  7: "통기타",
  8: "당구",
  9: "바둑",
};
const Map<int, String> outdoorHobbies = {
  1: "등산",
  2: "자전거",
  3: "캠핑",
  4: "낚시",
  5: "러닝/마라톤",
  6: "수영",
  7: "골프",
  8: "테니스",
  9: "족구",
};

// 내부 UI용 키 충돌 방지를 위한 local id 적용 (실외에 +100)
final List<Map<String, dynamic>> mergedHobbies = [
  ...indoorHobbies.entries.map((e) => {'id': e.key, 'name': e.value}),
  ...outdoorHobbies.entries.map((e) => {'id': e.key + 100, 'name': e.value}),
];

class _NewPostPageState extends State<NewPostPage> {
  final TextEditingController _textController = TextEditingController();

  Set<int> _selectedSubCategoryIds = {}; // 다중 선택

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: const HeaderPage(pageTitle: '피드 작성'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // 카테고리 선택 (해시태그 형태)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '카테고리',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          '(최대 3개 선택)',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CategoryChipSelector(
                      categories: mergedHobbies,
                      selectedIds: _selectedSubCategoryIds,
                      onChanged: (newSet) {
                        setState(() {
                          _selectedSubCategoryIds = newSet;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 글쓰기 필드
              TextFormField(
                controller: _textController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: "내용을 입력해주세요...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_selectedSubCategoryIds.isNotEmpty &&
                      _textController.text.trim().isNotEmpty) {
                    // 실제 ID로 변환해서 서버로 보낼 준비
                    final selectedIdsForServer = _selectedSubCategoryIds.map((id) {
                      return id >= 100 ? id - 100 : id;
                    }).toList();

                    // TODO: 서버 업로드 로직
                    print(" 업로드 ID: $selectedIdsForServer");

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("게시글이 업로드되었습니다.")),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("모든 항목을 입력해주세요.")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("게시하기", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// [yj] 카테고리 선택 위젯
class CategoryChipSelector extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final Set<int> selectedIds;
  final void Function(Set<int>) onChanged;
  final int maxSelection;

  const CategoryChipSelector({
    super.key,
    required this.categories,
    required this.selectedIds,
    required this.onChanged,
    this.maxSelection = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: categories.map((hobby) {
        final id = hobby['id'];
        final name = hobby['name'];
        final isSelected = selectedIds.contains(id);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: FilterChip(
            showCheckmark: false,
            label: Text('#$name'),
            selected: isSelected,
            onSelected: (selected) {
              final newSet = Set<int>.from(selectedIds);
              if (selected) {
                if (newSet.length < maxSelection) {
                  newSet.add(id);
                }
              } else {
                newSet.remove(id);
              }
              onChanged(newSet);
            },
          ),
        );
      }).toList(),
    );
  }
}

