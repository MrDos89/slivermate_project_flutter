import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UploadImage extends StatefulWidget {
  final Function(String) onUpload; // 콜백 추가

  const UploadImage({Key? key, required this.onUpload}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
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

  Future<void> _uploadToS3() async {
    if (_selectedFile == null) return;

    final String ec2IpAddress = dotenv.get("EC2_IP_ADDRESS");
    final String ec2Port = dotenv.get("EC2_PORT");

    String fileName =
        "upload/profile/${DateTime.now().millisecondsSinceEpoch}-${_selectedFile!.path.split('/').last}";
    String url =
        "http://$ec2IpAddress:$ec2Port/s3/presigned-url?fileName=$fileName";

    try {
      // 1. Spring Boot 서버에서 Pre-Signed URL 요청
      Response response = await Dio().get(url);

      if (response.statusCode == 200) {
        String presignedUrl = response.data;

        // 2. Pre-Signed URL을 사용하여 S3에 직접 업로드
        Response uploadResponse = await Dio().put(
          presignedUrl,
          data: _selectedFile!.readAsBytesSync(),
          options: Options(headers: {"Content-Type": "image/jpeg"}),
          onSendProgress: (sent, total) {
            setState(() {
              _progress = (sent / total);
            });
          },
        );

        if (uploadResponse.statusCode == 200) {
          setState(() {
            _uploadedUrl = presignedUrl.split("?")[0]; // S3 이미지 URL 저장
          });
          widget.onUpload(_uploadedUrl!);
        }
      }
    } catch (e) {
      print("업로드 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _pickImage,
          child:
              _selectedFile != null
                  ? ClipOval(
                    child: Image.file(
                      _selectedFile!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                  : CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.camera_alt,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
        ),
        const SizedBox(height: 10),
        _selectedFile != null
            ? ElevatedButton(
              onPressed: _uploadToS3,
              child: const Text("프로필 사진 업로드"),
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
