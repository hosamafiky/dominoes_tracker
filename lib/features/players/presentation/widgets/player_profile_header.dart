import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/entities/player.dart';
import '../cubit/stats_cubit.dart';

class PlayerProfileHeader extends StatelessWidget {
  const PlayerProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight;

    return BlocSelector<StatsCubit, StatsState, Player?>(
      selector: (state) => state.player,
      builder: (context, player) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Glow effect
                Positioned.fill(
                  top: -4,
                  bottom: -4,
                  left: -4,
                  right: -4,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppTheme.primary, AppTheme.primary.withValues(alpha: 0.5), Colors.transparent],
                      ),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 10, spreadRadius: 2)],
                      ),
                    ),
                  ),
                ),
                // Avatar
                Container(
                  width: 112.w,
                  height: 112.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 4.w),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
                  ),
                  child: ClipOval(
                    child: player?.avatarUrl == null ? null : AppCachedImage(imageUrl: player!.avatarUrl!, width: 112.w, height: 112.w, fit: BoxFit.cover),
                  ),
                ),
                // Rank Badge
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold,
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(color: borderColor, width: 2.w),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.emoji_events, size: 14.sp, color: AppTheme.backgroundDark),
                        4.horizontalSpace,
                        Text(
                          '#1',
                          style: TextStyle(color: AppTheme.backgroundDark, fontSize: 12.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            Text(
              player?.name ?? "Player Name",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            ),
            4.verticalSpace,
            Text(
              'DOMINO KING',
              style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600, fontSize: 14.sp, letterSpacing: 1.2),
            ),
          ],
        );
      },
    );
  }
}
