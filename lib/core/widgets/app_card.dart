import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final double? borderRadius;

  const AppCard({super.key, required this.child, this.padding, this.backgroundColor, this.borderColor, this.boxShadow, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? AppTheme.surfaceHighlight : Colors.white;
    final defaultBorder = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]!;

    return Container(
      padding: padding ?? EdgeInsets.all(20.dg),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(borderRadius ?? 24.r),
        border: Border.all(color: borderColor ?? defaultBorder),
        boxShadow: boxShadow ?? (!isDark ? [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10.r, offset: const Offset(0, 4))] : null),
      ),
      child: child,
    );
  }
}
