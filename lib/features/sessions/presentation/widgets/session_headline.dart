import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';

class SessionHeadline extends StatelessWidget {
  final String dateStr;

  const SessionHeadline({super.key, required this.dateStr});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Session',
          style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w800, letterSpacing: -1.0),
        ),
        8.verticalSpace,
        Row(
          children: [
            Icon(Icons.calendar_today, size: 16.sp, color: AppTheme.primary),
            8.horizontalSpace,
            Text(
              dateStr,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppTheme.primary.withValues(alpha: 0.8)),
            ),
          ],
        ),
      ],
    );
  }
}
