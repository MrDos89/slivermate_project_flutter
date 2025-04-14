import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart' as img;

class UploadClubThumbnail extends StatefulWidget {
  final Function(String) onUpload;

  const UploadClubThumbnail({Key? key, required this.onUpload}) : super(key: key);

  @override
  State<UploadClubThumbnail> createState() => _UploadClubThumbnailState();
}

class _UploadClubThumbnailState extends State<UploadClubThumbnail> {
  File? _selectedFile;
  String? _uploadedUrl;
  double _progress = 0.0;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndResizeImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final original = img.decodeImage(bytes);
      if (original == null) return;

      final resized = img.copyResize(original, width: 500);
      final tempFile = File('${Directory.systemTemp.path}/resized_${pickedFile.name}');
      await tempFile.writeAsBytes(img.encodeJpg(resized));

      setState(() {
        _selectedFile = tempFile;
      });
    }
  }

  Future<void> _uploadToS3() async {
    if (_selectedFile == null) return;

    final String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
    final String ec2Port = dotenv.get("EC2_PORT");

    String fileName = "upload/club/${DateTime.now().millisecondsSinceEpoch}-${_selectedFile!.path.split('/').last}";
    String url = "http://$ec2IpAddress:$ec2Port/s3/presigned-url?fileName=$fileName";

    try {
      final presigned = await Dio().get(url);
      if (presigned.statusCode == 200) {
        final presignedUrl = presigned.data;

        final uploadResp = await Dio().put(
          presignedUrl,
          data: _selectedFile!.readAsBytesSync(),
          options: Options(headers: {"Content-Type": "image/jpeg"}),
          onSendProgress: (sent, total) {
            setState(() {
              _progress = sent / total;
            });
          },
        );

        if (uploadResp.statusCode == 200) {
          final uploadedUrl = presignedUrl.split("?")[0];
          setState(() {
            _uploadedUrl = uploadedUrl;
          });
          widget.onUpload(uploadedUrl);
        }
      }
    } catch (e) {
      debugPrint("❌ 업로드 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickAndResizeImage,
          child: _selectedFile != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(_selectedFile!, width: 150, height: 150, fit: BoxFit.cover),
          )
              : Container(
            width: 150,
            height: 150,
            color: Colors.grey[300],
            child: const Icon(Icons.camera_alt, size: 40, color: Colors.white),
          ),
        ),
        const SizedBox(height: 12),
        if (_selectedFile != null)
          ElevatedButton(
            onPressed: _uploadToS3,
            child: const Text("썸네일 업로드"),
          ),
        if (_progress > 0 && _progress < 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LinearProgressIndicator(value: _progress),
          ),
        if (_uploadedUrl != null)
          Column(
            children: [
              const SizedBox(height: 10),
              const Text("업로드된 이미지 URL:"),
              SelectableText(_uploadedUrl!),
            ],
          ),
      ],
    );
  }
}
