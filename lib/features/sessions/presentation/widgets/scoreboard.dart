import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/session.dart';

class Scoreboard extends StatelessWidget {
  final Session session;

  const Scoreboard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TeamScore(name: session.team1Name, score: session.team1Score, isLeading: session.team1Score >= session.team2Score),
          Container(height: 60.h, width: 1.w, color: AppTheme.primary.withValues(alpha: 0.2)),
          _TeamScore(name: session.team2Name, score: session.team2Score, isLeading: session.team2Score > session.team1Score),
        ],
      ),
    );
  }
}

class _TeamScore extends StatelessWidget {
  final String name;
  final int score;
  final bool isLeading;

  const _TeamScore({required this.name, required this.score, required this.isLeading});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLeading)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(color: AppTheme.accentGold, borderRadius: BorderRadius.circular(4.r)),
            child: Text(
              'LEADING',
              style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          )
        else
          12.verticalSpace,
        8.verticalSpace,
        Text(
          score.toString(),
          style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        Text(
          name,
          style: TextStyle(fontSize: 14.sp, color: Colors.white.withValues(alpha: 0.6), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
