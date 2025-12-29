import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/enums/usecase_status.dart';
import '../../../../core/theme/app_theme.dart';

class SessionFooter extends StatelessWidget {
  final UseCaseStatus sessionStatus;
  final VoidCallback onCreateSession;

  const SessionFooter({super.key, required this.sessionStatus, required this.onCreateSession});

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
        child: GestureDetector(
          onTap: sessionStatus == UseCaseStatus.loading ? null : onCreateSession,
          child: Container(
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.4), blurRadius: 20.r, offset: const Offset(0, 0))],
            ),
            child: Center(
              child: sessionStatus == UseCaseStatus.loading
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Start Session',
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: Colors.black),
                        ),
                        8.horizontalSpace,
                        Icon(Icons.play_arrow, size: 20.sp, color: Colors.black),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
