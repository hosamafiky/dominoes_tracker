import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_theme.dart';

class AppStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final String? label;

  const AppStepper({super.key, required this.value, required this.onChanged, this.min = 1, this.max = 10, this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subBg = isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey[50]!;

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 4.dg, 4.dg, 4.dg),
      decoration: BoxDecoration(color: subBg, borderRadius: BorderRadius.circular(100.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label ?? '$value',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
          ),
          12.horizontalSpace,
          _StepperButton(
            icon: Icons.remove,
            onTap: () {
              if (value > min) onChanged(value - 1);
            },
            backgroundColor: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
            iconColor: Colors.grey[600]!,
          ),
          4.horizontalSpace,
          _StepperButton(
            icon: Icons.add,
            onTap: () {
              if (value < max) onChanged(value + 1);
            },
            backgroundColor: AppTheme.primary,
            iconColor: Colors.black,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  const _StepperButton({required this.icon, required this.onTap, required this.backgroundColor, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
        child: Center(
          child: Icon(icon, size: 14.sp, color: iconColor),
        ),
      ),
    );
  }
}
