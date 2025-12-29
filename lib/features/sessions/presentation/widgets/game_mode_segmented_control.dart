import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';

class GameModeSegmentedControl extends StatelessWidget {
  final bool isTeamMode;
  final ValueChanged<bool> onModeChanged;

  const GameModeSegmentedControl({super.key, required this.isTeamMode, required this.onModeChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.surfaceHighlight : Colors.grey[200]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GAME MODE',
          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: Colors.grey[500], letterSpacing: 1.5.w),
        ),
        12.verticalSpace,
        Container(
          padding: EdgeInsets.all(6.dg),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16.r)),
          child: Row(
            children: [
              Expanded(
                child: _SegmentItem(label: 'Individual', isActive: !isTeamMode, onTap: () => onModeChanged(false)),
              ),
              Expanded(
                child: _SegmentItem(label: 'Teams', isActive: isTeamMode, onTap: () => onModeChanged(true)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SegmentItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SegmentItem({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isActive ? (isDark ? AppTheme.primary : Colors.white) : Colors.transparent;
    final textColor = isActive ? Colors.black : Colors.grey[500]!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48.h,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: isActive && !isDark ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4.r, offset: const Offset(0, 2))] : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w800, fontSize: 14.sp),
          ),
        ),
      ),
    );
  }
}
