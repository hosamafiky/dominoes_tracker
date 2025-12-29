import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../sessions/domain/entities/session.dart';
import '../cubit/history_cubit.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session History', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list))],
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          final bool isLoading = state is HistoryLoading;
          final List<Session> history = isLoading
              ? List.generate(
                  5,
                  (index) => Session(
                    id: 'loading-$index',
                    date: DateTime.now(),
                    team1Score: 0,
                    team2Score: 0,
                    limit: 100,
                    team1Name: 'Team One',
                    team2Name: 'Team Two',
                    isCompleted: true,
                  ),
                )
              : (state is HistoryLoaded ? state.history : []);

          if (state is HistoryError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          }

          if (state is! HistoryLoading && (state is! HistoryLoaded || (state.history.isEmpty && !isLoading))) {
            if (state is HistoryLoaded && state.history.isEmpty) {
              return const Center(child: Text('No sessions yet. Start a game!'));
            }
            return const SizedBox();
          }

          return Skeletonizer(
            enabled: isLoading,
            child: ListView.separated(
              padding: EdgeInsets.all(20.dg),
              itemCount: history.length,
              separatorBuilder: (context, index) => 16.verticalSpace,
              itemBuilder: (context, index) {
                final session = history[index];
                final dateStr = '${session.date.day}/${session.date.month}/${session.date.year}';
                final winner = session.team1Score >= session.team2Score ? session.team1Name : session.team2Name;
                final score = '${session.team1Score} - ${session.team2Score}';
                return _buildHistoryCard(context, '${session.team1Name} vs ${session.team2Name}', dateStr, winner, score);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, String title, String date, String winner, String score) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: !isDark ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10.r, offset: Offset(0, 4.h))] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[500], fontWeight: FontWeight.w600),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
                child: Text(
                  'COMPLETED',
                  style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.bold, color: AppTheme.primary),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          Text(
            title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          16.verticalSpace,
          Row(children: [_buildSimpleStat('Winner', winner), const Spacer(), _buildSimpleStat('Final Score', score, isPrimary: true)]),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(String label, String value, {bool isPrimary = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
        ),
        4.verticalSpace,
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: isPrimary ? AppTheme.accentGold : Colors.white, fontSize: 14.sp),
        ),
      ],
    );
  }
}
