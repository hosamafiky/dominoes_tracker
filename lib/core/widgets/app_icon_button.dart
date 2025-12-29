import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_theme.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  final double? iconSize;

  const AppIconButton({super.key, required this.icon, required this.onTap, this.backgroundColor, this.iconColor, this.size, this.iconSize});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? Colors.white.withValues(alpha: 0.05) : AppTheme.surfaceHighlight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size ?? 40.w,
        height: size ?? 40.w,
        decoration: BoxDecoration(color: backgroundColor ?? defaultBg, shape: BoxShape.circle),
        child: Center(
          child: Icon(icon, size: iconSize ?? 18.sp, color: iconColor ?? Colors.grey[500]),
        ),
      ),
    );
  }
}
