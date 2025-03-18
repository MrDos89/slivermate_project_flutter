import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieIcon extends StatelessWidget {
  final String assetPath; // e.g. 'lib/animations/credit_card.json'
  final double width;
  final double height;
  final VoidCallback? onTap;

  const LottieIcon({
    Key? key,
    required this.assetPath,
    this.width = 48,
    this.height = 48,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Lottie.asset(
        assetPath,
        width: width,
        height: height,
        repeat: true,
        animate: true,
      ),
    );
  }
}
