import 'package:dominoes_tracker/core/widgets/app_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../players/domain/entities/player.dart';

class TeamRosterGrid extends StatelessWidget {
  const TeamRosterGrid({super.key, required this.team1, required this.team2});

  final List<Player> team1;
  final List<Player> team2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TeamCard(teamName: 'Team A', accentColor: AppTheme.primary, players: team1, isFocus: true),
        ),
        12.horizontalSpace,
        Expanded(
          child: TeamCard(teamName: 'Team B', accentColor: AppTheme.accentGold, players: team2),
        ),
      ],
    );
  }
}

class TeamCard extends StatefulWidget {
  final String teamName;
  final Color accentColor;
  final List<Player> players;
  final bool isFocus;

  const TeamCard({super.key, required this.teamName, required this.accentColor, required this.players, this.isFocus = false});

  @override
  State<TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
  late String teamName = widget.teamName;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = widget.isFocus ? (isDark ? const Color(0xFF152015) : Colors.white) : (isDark ? const Color(0xFF1A1A1A) : Colors.white);

    return Container(
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: widget.isFocus ? widget.accentColor.withValues(alpha: 0.2) : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]!),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    teamName.toUpperCase(),
                    style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: widget.accentColor, letterSpacing: 1.w),
                  ),
                  Icon(Icons.more_horiz, size: 16.sp, color: Colors.white.withValues(alpha: 0.2)),
                ],
              ),
              16.verticalSpace,
              Column(
                children: widget.players.indexed.map((e) => _PlayerRow(player: e.$2, role: e.$1 == 0 ? 'Host' : 'Player', isHost: e.$1 == 0)).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final Player player;
  final String role;
  final bool isHost;

  const _PlayerRow({required this.player, required this.role, required this.isHost});
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
                child: AppCachedImage(imageUrl: player.avatarUrl!),
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
                player.name,
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
