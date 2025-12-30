import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/enums/usecase_status.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/stats_cubit.dart';
import '../widgets/player_insights_section.dart';
import '../widgets/player_profile_header.dart';
import '../widgets/player_stats_grid.dart';

class PlayerStatsPage extends StatelessWidget {
  const PlayerStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Stats', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: (isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight).withValues(alpha: 0.95),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.dg),
          child: Container(
            decoration: BoxDecoration(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05), shape: BoxShape.circle),
            child: IconButton(icon: const Icon(Icons.arrow_back, size: 20), onPressed: () => Navigator.pop(context), padding: EdgeInsets.zero),
          ),
        ),
      ),
      body: BlocBuilder<StatsCubit, StatsState>(
        builder: (context, state) {
          final bool isLoading = state.statsStatus == UseCaseStatus.loading || state.playerStatus == UseCaseStatus.initial;

          if (state.statsFailure != null && state.statsStatus == UseCaseStatus.failure) {
            return Center(
              child: Text(state.statsFailure!.message, style: const TextStyle(color: Colors.red)),
            );
          }

          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 40.h),
              child: Column(
                children: [
                  PlayerProfileHeader(),
                  32.verticalSpace,
                  WinRateSection(state.stats.winRate),
                  32.verticalSpace,
                  PlayerStatsGrid(state.stats),
                  24.verticalSpace,
                  PlayerInsightsSection(state.stats),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
