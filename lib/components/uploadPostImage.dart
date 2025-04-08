import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UploadPostImage extends StatefulWidget {
  final Function(String) onUpload; // 콜백 추가

  const UploadPostImage({Key? key, required this.onUpload}) : super(key: key);

  @override
  _UploadPostImage createState() => _UploadPostImage();
}

Future<String?> uploadToS3(File file) async {
  final String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
  final String ec2Port = dotenv.get("EC2_PORT");

  final fileName =
      "upload/post/${DateTime.now().millisecondsSinceEpoch}-${file.path.split('/').last}";
  final url =
      "http://$ec2IpAddress:$ec2Port/s3/presigned-url?fileName=$fileName";

  try {
    final presigned = await Dio().get(url);
    if (presigned.statusCode == 200) {
      final presignedUrl = presigned.data;

      final uploadResp = await Dio().put(
        presignedUrl,
        data: file.readAsBytesSync(),
        options: Options(headers: {"Content-Type": "image/jpeg"}),
      );

      if (uploadResp.statusCode == 200) {
        return presignedUrl.split("?")[0]; // ← 이게 최종 S3 URL
      }
    }
  } catch (e) {
    debugPrint("❌ 업로드 실패: $e");
  }

  return null;
}

class _UploadPostImage extends State<UploadPostImage> {
  File? _selectedFile;
  String? _uploadedUrl;
  double _progress = 0.0;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        _selectedFile != null
            ? ElevatedButton(
          onPressed: () async {
            if (_selectedFile != null) {
              final url = await uploadToS3(_selectedFile!);
              if (url != null) {
                setState(() {
                  _uploadedUrl = url;
                });
                widget.onUpload(url); // 콜백으로 URL 전달
              }
            }
          },
          child: const Text("이미지 업로드"),
        )
            : const SizedBox(),
        _progress > 0
            ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LinearProgressIndicator(value: _progress),
        )
            : const SizedBox(),
        _uploadedUrl != null
            ? Column(
          children: [
            const SizedBox(height: 10),
            Text("업로드된 이미지 URL:"),
            SelectableText(_uploadedUrl!),
          ],
        )
            : const SizedBox(),
      ],
    );
  }
}
