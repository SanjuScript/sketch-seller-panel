import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationWidget extends StatelessWidget {
  final String animationPath;
  final double? width;
  final double? height;
  final bool loop;
  final bool reverse;
  final Alignment? alignment;
  final bool autoplay;

  const LottieAnimationWidget({
    super.key,
    required this.animationPath,
    this.width,
    this.height,
    this.loop = true,
    this.reverse = false,
    this.alignment = Alignment.center,
    this.autoplay = true,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.center,
      child: Lottie.asset(
        frameRate: FrameRate.max,
       fit: BoxFit.contain,
        animationPath,
        width: width ?? 150,
        height: height ?? 150,
        repeat: loop,
        reverse: reverse,
        animate: autoplay,
      ),
    );
  }
}
