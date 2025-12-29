import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_stepper.dart';

class SessionSettingsCard extends StatelessWidget {
  final int playersPerTeam;
  final int scoreLimit;
  final ValueChanged<int> onPlayersPerTeamChanged;
  final VoidCallback onScoreLimitTap;

  const SessionSettingsCard({
    super.key,
    required this.playersPerTeam,
    required this.scoreLimit,
    required this.onPlayersPerTeamChanged,
    required this.onScoreLimitTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _IconContainer(icon: Icons.groups, backgroundColor: AppTheme.primary.withValues(alpha: 0.1), iconColor: AppTheme.primary),
                  12.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Players per Team',
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Total players: ${playersPerTeam * 2}',
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
              AppStepper(value: playersPerTeam, onChanged: onPlayersPerTeamChanged, min: 1, max: 4),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Divider(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100], height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _IconContainer(icon: Icons.emoji_events, backgroundColor: AppTheme.accentGold.withValues(alpha: 0.1), iconColor: AppTheme.accentGold),
                  12.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Score Limit',
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Game ends at',
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
              _DropdownButton(scoreLimit: scoreLimit, onTap: onScoreLimitTap),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconContainer extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _IconContainer({required this.icon, required this.backgroundColor, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: Icon(icon, size: 20.sp, color: iconColor),
      ),
    );
  }
}

class _DropdownButton extends StatelessWidget {
  final int scoreLimit;
  final VoidCallback onTap;

  const _DropdownButton({required this.scoreLimit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey[50], borderRadius: BorderRadius.circular(12.r)),
        child: Row(
          children: [
            Text(
              '$scoreLimit pts',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800),
            ),
            4.horizontalSpace,
            Icon(Icons.expand_more, size: 16.sp, color: Colors.grey[500]),
          ],
        ),
      ),
    );
  }
}
