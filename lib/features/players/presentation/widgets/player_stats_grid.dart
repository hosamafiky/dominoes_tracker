import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/player_stats.dart';

class WinRateSection extends StatelessWidget {
  final double winRate;

  const WinRateSection(this.winRate, {super.key});

  @override
  Widget build(BuildContext context) {
    final winRatePct = (winRate * 100).toInt();
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect
        Container(
          width: 160.w,
          height: 160.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primary.withValues(alpha: 0.1)),
        ),
        SizedBox(
          width: 160.w,
          height: 160.w,
          child: CircularProgressIndicator(value: 1.0, strokeWidth: 8.w, color: Colors.white.withValues(alpha: 0.1)),
        ),
        SizedBox(
          width: 160.w,
          height: 160.w,
          child: CircularProgressIndicator(value: winRate, strokeWidth: 8.w, color: AppTheme.primary, strokeCap: StrokeCap.round),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$winRatePct%',
              style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w800, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            Text(
              'WIN RATE',
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: Colors.grey[400]),
            ),
          ],
        ),
      ],
    );
  }
}

class PlayerStatsGrid extends StatelessWidget {
  final PlayerStats stats;

  const PlayerStatsGrid(this.stats, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.cardDark : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!;

    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(
          context,
          icon: Icons.casino,
          iconColor: Colors.grey[400]!,
          label: 'GAMES',
          value: stats.totalGames.toString(),
          bgColor: cardColor,
          borderColor: borderColor,
        ),
        _buildStatCard(
          context,
          icon: Icons.emoji_events,
          iconColor: AppTheme.primary,
          label: 'WINS',
          value: stats.wins.toString(),
          bgColor: cardColor,
          borderColor: borderColor,
        ),
        _buildStatCard(
          context,
          icon: Icons.close,
          iconColor: AppTheme.accentOrange,
          label: 'LOSSES',
          value: stats.losses.toString(),
          bgColor: cardColor,
          borderColor: borderColor,
        ),
        _buildStreakCard(context, stats.currentStreak),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: iconColor),
              8.horizontalSpace,
              Text(
                label,
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, letterSpacing: 1.2, color: Colors.grey[500]),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, int streak) {
    return Container(
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.primary.withValues(alpha: 0.2), AppTheme.cardDark]),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Icon(Icons.local_fire_department, size: 64.sp, color: AppTheme.primary.withValues(alpha: 0.1)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.local_fire_department, size: 20.sp, color: AppTheme.primary),
                  8.horizontalSpace,
                  Text(
                    'STREAK',
                    style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppTheme.primary),
                  ),
                ],
              ),
              Text(
                '+$streak',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
