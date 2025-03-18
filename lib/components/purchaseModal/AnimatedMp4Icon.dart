import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// MP4 동영상을 아이콘처럼 보여주는 위젯
class AnimatedMp4Icon extends StatefulWidget {
  final String assetPath; // 예: 'lib/videos/credit_card.mp4'
  final double width;
  final double height;

  const AnimatedMp4Icon({
    Key? key,
    required this.assetPath,
    this.width = 48,
    this.height = 48,
  }) : super(key: key);

  @override
  _AnimatedMp4IconState createState() => _AnimatedMp4IconState();
}

class _AnimatedMp4IconState extends State<AnimatedMp4Icon> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // MP4 파일 재생을 위한 VideoPlayerController.asset
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..initialize().then((_) {
        setState(() => _initialized = true);
        _controller.setLooping(true); // 반복 재생
        _controller.play(); // 자동 재생
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      // 초기화 전 로딩 표시
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    // 초기화 후 VideoPlayer 표시
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: VideoPlayer(_controller),
    );
  }
}
