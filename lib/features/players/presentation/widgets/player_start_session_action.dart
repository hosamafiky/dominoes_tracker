import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class PlayerStartSessionAction extends StatelessWidget {
  const PlayerStartSessionAction({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      bottom: 80.h,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(20.dg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              (isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight).withValues(alpha: 0),
              (isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight),
            ],
            stops: const [0, 0.4],
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 60.h,
          child: ElevatedButton(
            onPressed: () => context.push('/session-setup'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: AppTheme.backgroundDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              elevation: 10,
              shadowColor: AppTheme.primary.withValues(alpha: 0.4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'START SESSION',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                8.horizontalSpace,
                const Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
