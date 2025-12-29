import 'package:dominoes_tracker/features/sessions/presentation/cubit/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/usecase_status.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../injection_container.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => sl<SessionCubit>()..loadSessionsCount(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Stack(
              children: [
                // Background Pattern (Subtle dots)
                Positioned.fill(
                  child: CustomPaint(painter: DotPatternPainter(color: AppTheme.primary.withOpacity(isDark ? 0.05 : 0.03))),
                ),
                // Content Wrapper
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
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
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      boxShadow: [
                                        BoxShadow(color: AppTheme.primary.withOpacity(0.25), blurRadius: 40, spreadRadius: 10),
                                        BoxShadow(color: AppTheme.accentGold.withOpacity(0.15), blurRadius: 40, spreadRadius: 5),
                                      ],
                                    ),
                                  ),
                                  // Logo Image
                                  Container(
                                    width: 192,
                                    height: 192,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                                      image: const DecorationImage(
                                        image: NetworkImage(
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCkrV5AZPhCp_BBpyl6f1ouuwRdmWLoDhFWJjI536GP-WvYd6xLoPoX9Kti_RkPjkWouFARNi8-IEoragh-GyenQQjrOWCwQYrL095vxTHxthkMtwrufVkMdKhI2PS0Z9lnSpI8Nk3RopqiiEBDa3gkviVdJgRiuuy3H_cSLaRGUEDAZnGgdmGKUuP1G4j6NmKXKYlUraPmlWHcBQyN4fBEQN5J_4HYCc0MHEGJ5YRiHEKYwClNSeBG4xyaXOCgSirBLB6gLxfwGG6A',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
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
                                  const SizedBox(height: 12),
                                  Text(
                                    'Track scores. Switch teams.\nPlay fast.',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: (isDark ? Colors.white : AppTheme.textDark).withOpacity(0.6),
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
                            const SizedBox(height: 16),
                            // Secondary Action
                            _ActionButton(onPressed: () {}, icon: Icons.history_rounded, label: 'SESSION HISTORY', isPrimary: false),
                            const SizedBox(height: 24),
                            // Footer Stats
                            BlocBuilder<SessionCubit, SessionState>(
                              builder: (context, state) {
                                print(state.count);

                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(color: (isDark ? Colors.white : AppTheme.textDark).withOpacity(0.05)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.emoji_events_rounded, color: AppTheme.accentGold, size: 20),
                                      const SizedBox(width: 8),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Total Sessions Played: ',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: (isDark ? Colors.white : AppTheme.textDark).withOpacity(0.5),
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
      ),
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: isPrimary ? 64 : 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isPrimary ? AppTheme.primary : (isDark ? Colors.white.withOpacity(0.05) : AppTheme.textDark.withOpacity(0.05)),
            borderRadius: BorderRadius.circular(16),
            border: isPrimary ? null : Border.all(color: (isDark ? Colors.white : AppTheme.textDark).withOpacity(0.1)),
            boxShadow: isPrimary ? [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 4))] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: isPrimary ? 28 : 24, color: isPrimary ? AppTheme.backgroundDark : (isPrimary ? null : AppTheme.primary.withOpacity(0.8))),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
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
