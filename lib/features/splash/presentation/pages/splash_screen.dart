import 'package:dominoes_tracker/features/sessions/presentation/cubit/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/usecase_status.dart';
import '../../../../core/theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Builder(
      builder: (context) {
        return Scaffold(
          body: Stack(
            children: [
              // Background Pattern (Subtle dots)
              Positioned.fill(
                child: CustomPaint(
                  painter: DotPatternPainter(color: AppTheme.primary.withValues(alpha: isDark ? 0.05 : 0.03)),
                ),
              ),
              // Content Wrapper
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                  child: Column(
                    children: [
                      const Spacer(flex: 1),
                      // Hero Section
                      Expanded(
                        flex: 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo Container
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glow Effect
                                Container(
                                  width: 200.w,
                                  height: 200.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32.r),
                                    boxShadow: [
                                      BoxShadow(color: AppTheme.primary.withValues(alpha: 0.25), blurRadius: 40.r, spreadRadius: 10.r),
                                      BoxShadow(color: AppTheme.accentGold.withValues(alpha: 0.15), blurRadius: 40.r, spreadRadius: 5.r),
                                    ],
                                  ),
                                ),
                                // Logo Image
                                Container(
                                  width: 192.w,
                                  height: 192.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32.r),
                                    image: DecorationImage(image: AssetImage('assets/images/lighting_domino.png'), fit: BoxFit.cover),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.w),
                                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20.r, offset: Offset(0, 10.h))],
                                  ),
                                ),
                              ],
                            ),
                            32.verticalSpace,
                            // Text Content
                            Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Domino ',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, color: isDark ? Colors.white : AppTheme.textDark),
                                      ),
                                      TextSpan(
                                        text: 'Tracker',
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, color: AppTheme.primary),
                                      ),
                                    ],
                                  ),
                                ),
                                12.verticalSpace,
                                Text(
                                  'Track scores. Switch teams.\nPlay fast.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: (isDark ? Colors.white : AppTheme.textDark).withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Actions Section
                      Column(
                        children: [
                          // Primary Action
                          _ActionButton(
                            onPressed: () {
                              context.push('/players');
                            },
                            icon: Icons.play_circle_filled_rounded,
                            label: 'START NEW SESSION',
                            isPrimary: true,
                          ),
                          16.verticalSpace,
                          // Secondary Action
                          _ActionButton(onPressed: () {}, icon: Icons.history_rounded, label: 'SESSION HISTORY', isPrimary: false),
                          24.verticalSpace,
                          // Footer Stats
                          BlocBuilder<SessionCubit, SessionState>(
                            builder: (context, state) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(100.r),
                                  border: Border.all(color: (isDark ? Colors.white : AppTheme.textDark).withValues(alpha: 0.1)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.emoji_events_rounded, color: AppTheme.accentGold, size: 20.sp),
                                    8.horizontalSpace,
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Total Sessions Played: ',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: (isDark ? Colors.white : AppTheme.textDark).withValues(alpha: 0.5),
                                            ),
                                          ),
                                          TextSpan(
                                            text: "${state.countStatus == UseCaseStatus.success ? state.count : '...'}",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.textDark),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final bool isPrimary;

  const _ActionButton({required this.onPressed, required this.icon, required this.label, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: isPrimary ? 64.h : 56.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isPrimary ? AppTheme.primary : (isDark ? Colors.white.withValues(alpha: 0.05) : AppTheme.textDark.withValues(alpha: 0.05)),
            borderRadius: BorderRadius.circular(16.r),
            border: isPrimary ? null : Border.all(color: (isDark ? Colors.white : AppTheme.textDark).withValues(alpha: 0.1)),
            boxShadow: isPrimary ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 20.r, offset: Offset(0, 4.h))] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isPrimary ? 28.sp : 24.sp,
                color: isPrimary ? AppTheme.backgroundDark : (isPrimary ? null : AppTheme.primary.withValues(alpha: 0.8)),
              ),
              12.horizontalSpace,
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2.sp,
                  color: isPrimary ? AppTheme.backgroundDark : (isDark ? Colors.white : AppTheme.textDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DotPatternPainter extends CustomPainter {
  final Color color;

  DotPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    double spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
