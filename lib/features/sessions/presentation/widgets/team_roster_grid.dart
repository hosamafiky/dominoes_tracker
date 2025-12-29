import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';

class TeamRosterGrid extends StatelessWidget {
  const TeamRosterGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TeamCard(teamName: 'Team A', accentColor: AppTheme.primary, p1: 'Julian', p2: 'Sarah', isFocus: true),
        ),
        12.horizontalSpace,
        Expanded(
          child: TeamCard(teamName: 'Team B', accentColor: AppTheme.accentGold, p1: 'Marcus', p2: 'David'),
        ),
      ],
    );
  }
}

class TeamCard extends StatelessWidget {
  final String teamName;
  final Color accentColor;
  final String p1;
  final String p2;
  final bool isFocus;

  const TeamCard({super.key, required this.teamName, required this.accentColor, required this.p1, required this.p2, this.isFocus = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isFocus ? (isDark ? const Color(0xFF152015) : Colors.white) : (isDark ? const Color(0xFF1A1A1A) : Colors.white);

    return Container(
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isFocus ? accentColor.withValues(alpha: 0.2) : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]!)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -10,
            right: -10,
            child: Text(
              teamName.substring(5),
              style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w900, color: Colors.white.withValues(alpha: 0.03)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    teamName.toUpperCase(),
                    style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: accentColor, letterSpacing: 1.w),
                  ),
                  Icon(Icons.more_horiz, size: 16.sp, color: Colors.white.withValues(alpha: 0.2)),
                ],
              ),
              16.verticalSpace,
              _PlayerRow(name: p1, role: 'Host', isHost: true),
              12.verticalSpace,
              _PlayerRow(name: p2, role: 'Rookie', isHost: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final String name;
  final String role;
  final bool isHost;

  const _PlayerRow({required this.name, required this.role, required this.isHost});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.surfaceHighlight, width: 2.w),
                color: Colors.grey[800],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: Icon(Icons.person, size: 20.sp, color: Colors.grey[300]),
              ),
            ),
            if (isHost)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(4.r)),
                child: Text(
                  'D',
                  style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w900, color: Colors.black),
                ),
              ),
          ],
        ),
        8.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              Text(
                role,
                style: TextStyle(fontSize: 9.sp, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
