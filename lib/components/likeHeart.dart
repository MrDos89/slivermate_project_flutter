import 'package:flutter/material.dart';
import 'package:slivermate_project_flutter/vo/likeVo.dart';
import 'package:slivermate_project_flutter/vo/postVo.dart';
import 'package:dio/dio.dart';

class LikeHeart extends StatefulWidget {
  final int postId;
  final int userId;
  final int initialLikes;
  final bool initiallyLiked;
  final void Function(bool isLiked)? onLikeChanged;
  final bool fetchInitialLikeStatus;

  const LikeHeart({
    super.key,
    required this.postId,
    required this.userId,
    required this.initialLikes,
    required this.initiallyLiked,
    this.onLikeChanged,
    this.fetchInitialLikeStatus = true,
  });

  @override
  State<LikeHeart> createState() => _LikeHeartState();
}

class _LikeHeartState extends State<LikeHeart> with SingleTickerProviderStateMixin {
  late int _likes;
  late bool _isLiked;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late List<PostVo> _postsWithLikes;

  final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://43.201.50.194:18090/api/like', // 서버 URL
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    sendTimeout: const Duration(seconds: 5),
    contentType: 'application/json',
  ));

  @override
  void initState() {
    super.initState();
    _likes = widget.initialLikes;
    _isLiked = widget.initiallyLiked;
    _postsWithLikes = [];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    debugPrint("🧡 초기 하트 상태: postId ${widget.postId}, liked: $_isLiked");
    // 좋아요 상태 최신화 (선택적)
    // _fetchLikeStatus();

    if (widget.fetchInitialLikeStatus) {
      _fetchLikeStatus();
    }
  }

  Future<void> _fetchLikeStatus() async {
    try {
      final isLiked = await LikeService.isLiked(widget.postId, widget.userId);
      final likeCount = await LikeService.getLikeCount(widget.postId);

      setState(() {
        _isLiked = isLiked;
        _likes = likeCount;
      });
    } catch (e) {
      debugPrint('❌ 초기 좋아요 상태 불러오기 실패: $e');
    }
  }


  Future<void> _onTapLike() async {
    final prevLiked = _isLiked;
    final prevLikes = _likes;

    setState(() {
      _isLiked = !prevLiked;
      _likes += _isLiked ? 1 : -1;
    });

    try {
      final response = await dio.post(
        '/toggle',
        data: {
          'post_id': widget.postId,
          'user_id': widget.userId,
        },
      );

      if (response.statusCode == 200) {
        // 서버에서는 단순 메시지 ("좋아요 완료")만 내려주므로 별도 파싱 불필요

        if (_isLiked) {
          _controller.forward().then((_) => _controller.reverse());
        }

        widget.onLikeChanged?.call(_isLiked);
      } else {
        // 실패 시 롤백
        setState(() {
          _isLiked = prevLiked;
          _likes = prevLikes;
        });
      }
    } catch (e) {
      setState(() {
        _isLiked = prevLiked;
        _likes = prevLikes;
      });
      print('❌ 좋아요 토글 실패: $e');
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