import 'package:cached_network_image/cached_network_image.dart';
import 'package:drawer_panel/ANIMATIONS/shimmer_animation.dart';
import 'package:flutter/material.dart';

class CustomCachedImageDisplayer extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const CustomCachedImageDisplayer({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ??
            Center(
              child: ShimmerContainer(
                height: height ?? 100,
                width: width ?? 100,
                borderraduis: borderRadius ?? BorderRadius.circular(0),
              ),
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            const Center(
              child: Icon(Icons.error, color: Colors.red),
            ),
        imageBuilder: (context, imageProvider) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              ),
            ),
          );
        },
      ),
    );
  }
}
