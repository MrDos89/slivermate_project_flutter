import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/vo/likeVo.dart';

class LikeHeart extends StatefulWidget {
  final int postId;
  final int userId;
  final int initialLikes;
  final bool initiallyLiked;
  final void Function(bool isLiked)? onLikeChanged;

  const LikeHeart({
    super.key,
    required this.postId,
    required this.userId,
    required this.initialLikes,
    required this.initiallyLiked,
    this.onLikeChanged,
  });

  @override
  State<LikeHeart> createState() => _LikeHeartState();
}

class _LikeHeartState extends State<LikeHeart> with SingleTickerProviderStateMixin {
  late int _likes;
  late bool _isLiked;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _likes = widget.initialLikes;
    _isLiked = widget.initiallyLiked;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // 좋아요 상태 최신화 (선택적)
    _fetchLikeStatus();
  }

  Future<void> _fetchLikeStatus() async {
    try {
      final result = await LikeService.getLikeStatus(
        postId: widget.postId,
        userId: widget.userId,
      );
      setState(() {
        _isLiked = result['isLiked'] == 1;
        _likes = result['totalLikes'] ?? _likes;
      });
    } catch (e) {
      print('❌ 초기 좋아요 상태 불러오기 실패: $e');
    }
  }

  Future<void> _onTapLike() async {
    try {
      final nowLiked = await LikeService.toggleLike(
        postId: widget.postId,
        userId: widget.userId,
      );

      setState(() {
        _isLiked = nowLiked;
        _likes += nowLiked ? 1 : -1;
      });

      if (nowLiked) {
        _controller.forward().then((_) => _controller.reverse());
      }

      if (widget.onLikeChanged != null) {
        widget.onLikeChanged!(_isLiked);
      }
    } catch (e) {
      print('좋아요 토글 실패: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTapLike,
      child: Row(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.red : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 4),
          Text('$_likes'),
        ],
      ),
    );
  }
}