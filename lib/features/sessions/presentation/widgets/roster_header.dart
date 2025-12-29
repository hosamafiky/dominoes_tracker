import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';

class SessionActionChip extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;
  final bool hasPulse;

  const SessionActionChip({super.key, required this.label, required this.bg, required this.textColor, this.hasPulse = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg == Colors.transparent ? (isDark ? AppTheme.surfaceHighlight : Colors.grey[200]!) : bg,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: hasPulse ? [BoxShadow(color: AppTheme.accentGold.withValues(alpha: 0.3), blurRadius: 10.r, offset: const Offset(0, 0))] : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasPulse) ...[Icon(Icons.shuffle, size: 12.sp, color: textColor), 4.horizontalSpace],
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: textColor),
          ),
        ],
      ),
    );
  }
}

class RosterHeader extends StatelessWidget {
  const RosterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Current Roster',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
        ),
        Row(
          children: [
            const SessionActionChip(label: 'Manual', bg: Colors.transparent, textColor: Colors.grey),
            8.horizontalSpace,
            const SessionActionChip(label: 'Randomize', bg: AppTheme.accentGold, textColor: Colors.black, hasPulse: true),
          ],
        ),
      ],
    );
  }
}
