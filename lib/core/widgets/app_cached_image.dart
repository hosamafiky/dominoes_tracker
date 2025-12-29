import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ??
            Skeletonizer(
              enabled: true,
              child: Container(
                width: width ?? double.infinity,
                height: height ?? double.infinity,
                color: Colors.white24,
                child: const Center(child: Icon(Icons.image, color: Colors.white)),
              ),
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Container(
              color: Colors.white.withValues(alpha: 0.1),
              child: Icon(Icons.error_outline, color: Colors.red[400], size: 24.sp),
            ),
      ),
    );
  }
}
