import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart';
import 'package:slivermate_project_flutter/vo/postVo.dart';
import 'package:slivermate_project_flutter/components/uploadPostImage.dart';

class PostWriterForm extends StatefulWidget {
  final int? clubId;
  final VoidCallback? onPostUploaded;

  const PostWriterForm({super.key, this.clubId, this.onPostUploaded});

  @override
  State<PostWriterForm> createState() => _PostWriterFormState();
}

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

final List<Map<String, dynamic>> mergedHobbies = [
  ...indoorHobbies.entries.map((e) => {'id': e.key, 'name': e.value}),
  ...outdoorHobbies.entries.map((e) => {'id': e.key + 100, 'name': e.value}),
];

class _PostWriterFormState extends State<PostWriterForm> {
  final TextEditingController _textController = TextEditingController();
  Set<int> _selectedSubCategoryIds = {};
  List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 4) return;
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      debugPrint("📸 원본 이미지 경로: ${image.path}");
      final bytes = await image.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      if (originalImage != null) {
        final resizedImage = img.copyResize(originalImage, width: 500);
        final tempDir = Directory.systemTemp;
        final resizedFile = File(
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await resizedFile.writeAsBytes(img.encodeJpg(resizedImage));

        debugPrint("📏 리사이즈된 이미지 경로: ${resizedFile.path}");
        setState(() {
          _selectedImages.add(XFile(resizedFile.path));
        });
      } else {
        debugPrint("⚠️ 이미지 디코딩 실패!");
      }
    } else {
      debugPrint("❌ 이미지 선택 안됨");
    }
  }

  Future<bool> uploadPost(PostVo postData) async {
    try {
      // final String apiUrl = 'http://54.180.127.164:18090/api/post';
      final String apiUrl = 'http://3.39.240.55:18090/api/post'; // api 주소 변경
      final dio = Dio();

      final response = await dio.post(
        apiUrl,
        data: postData.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('게시글 업로드 성공: ${response.data}');
        return true; // ⬅️ 성공
      } else {
        debugPrint('서버 응답 에러: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('업로드 중 오류 발생: $e');
      return false;
    }
  }

  Future<void> _submitPost() async {
    if (_selectedSubCategoryIds.isNotEmpty &&
        _textController.text.trim().isNotEmpty) {
      final selectedIdsForServer =
          _selectedSubCategoryIds
              .map((id) => id >= 100 ? id - 100 : id)
              .toList();
      final content = _textController.text.trim();
      List<String> uploadedUrls = [];
      for (final image in _selectedImages) {
        final url = await uploadToS3(File(image.path));
        if (url != null) uploadedUrls.add(url);
      }

      debugPrint("🖼️ 서버에 전송할 이미지 경로 리스트: $uploadedUrls");

      final post = PostVo(
        postId: 0,
        regionId: 1,
        postUserId: 1,
        clubId: widget.clubId ?? 0,
        postCategoryId: 2,
        postSubCategoryId: selectedIdsForServer.first,
        postNote: content,
        postImages: uploadedUrls,
        postLikeCount: 0,
        postCommentCount: 0,
        isHidden: false,
        postReportCount: 0,
        registerDate: DateTime.now(),
        comments: [],
        userNickname: "",
        userThumbnail: "",
        updDate: DateTime.now(),
      );

      final result = await uploadPost(post);

      if (result == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("게시글이 업로드되었습니다.")));
        widget.onPostUploaded?.call();
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("모든 항목을 입력해주세요.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      children: [
        const SizedBox(height: 16),
        const Text(
          '카테고리 (최대 3개 선택)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        CategoryChipSelector(
          categories: mergedHobbies,
          selectedIds: _selectedSubCategoryIds,
          onChanged:
              (newSet) => setState(() => _selectedSubCategoryIds = newSet),
        ),
        const SizedBox(height: 24),
        const Text(
          '이미지 업로드 (최대 4장)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._selectedImages.map(
              (image) => Stack(
                children: [
                  Image.file(
                    File(image.path),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap:
                          () => setState(() => _selectedImages.remove(image)),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_selectedImages.length < 4)
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.add_a_photo),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _textController,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: "내용을 입력해주세요...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _submitPost,
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
    );
  }
}

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
      children:
          categories.map((hobby) {
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
                    if (newSet.length < maxSelection) newSet.add(id);
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
