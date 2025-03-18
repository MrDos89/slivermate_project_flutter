import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// MP4 동영상을 아이콘처럼 보여주는 위젯
/// - 초기부터 자동 재생(loop)
/// - 탭하면 onTap 콜백(모달 열기 등) 실행
class AnimatedMp4Icon extends StatefulWidget {
  final String assetPath; // 예: 'lib/videos/credit_card.mp4'
  final double width;
  final double height;
  final VoidCallback? onTap; // 동영상 영역 탭 시 실행할 콜백

  const AnimatedMp4Icon({
    Key? key,
    required this.assetPath,
    this.width = 48,
    this.height = 48,
    this.onTap,
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
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..initialize()
          .then((_) {
            setState(() => _initialized = true);
            _controller.setLooping(true);
            _controller.play(); // 초기부터 자동 재생
          })
          .catchError((error) {
            debugPrint('Error initializing video: $error');
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 탭 시 모달 열기 등의 외부 콜백 실행
  void _handleTap() {
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return GestureDetector(
      onTap: _handleTap,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: VideoPlayer(_controller),
      ),
    );
  }
}
