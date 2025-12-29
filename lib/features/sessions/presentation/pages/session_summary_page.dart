import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/usecase_status.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/session.dart';
import '../cubit/session_cubit.dart';

class SessionSummaryPage extends StatelessWidget {
  const SessionSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, state) {
          if (state.sessionStatus == UseCaseStatus.success && state.session != null) {
            final session = state.session!;
            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(context),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.dg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWinnerSection(context, session),
                        32.h.verticalSpace,
                        _buildMVPSection(context), // Placeholder for now
                        32.h.verticalSpace,
                        _buildFunStatsSection(context), // Placeholder for now
                        32.h.verticalSpace,
                        _buildFinalRankings(context, session),
                        120.h.verticalSpace, // Bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomSheet: _buildBottomActions(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.backgroundDark], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Center(
            child: Icon(Icons.emoji_events_rounded, size: 80.sp, color: AppTheme.accentGold),
          ),
        ),
      ),
      leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
      title: const Text('Session Summary', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildWinnerSection(BuildContext context, Session session) {
    final winner = session.team1Score >= session.team2Score ? session.team1Name : session.team2Name;
    return Center(
      child: Column(
        children: [
          Text(
            'WINNER',
            style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, letterSpacing: 2.sp),
          ),
          8.h.verticalSpace,
          Text(
            winner,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, color: Colors.white),
          ),
          4.h.verticalSpace,
          Text(
            '${session.team1Score} - ${session.team2Score}',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
          ),
        ],
      ),
    );
  }

  Widget _buildMVPSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MVP OF THE SESSION',
          style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12.sp),
        ),
        16.h.verticalSpace,
        Container(
          padding: EdgeInsets.all(16.dg),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundColor: AppTheme.accentGold,
                child: Icon(Icons.person, size: 40.sp, color: Colors.black),
              ),
              16.w.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  const Text('45 points contributed', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const Spacer(),
              Icon(Icons.workspace_premium, color: AppTheme.accentGold, size: 32.sp),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFunStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FUN STATS',
          style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12.sp),
        ),
        16.h.verticalSpace,
        Row(
          children: [
            Expanded(child: _buildStatCard('Most Wins', 'Sarah Miller', Icons.trending_up)),
            16.w.horizontalSpace,
            Expanded(child: _buildStatCard('The Brick', 'Mike Ross', Icons.block, color: Colors.red)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String name, IconData icon, {Color color = AppTheme.primary}) {
    return Container(
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24.sp),
          12.h.verticalSpace,
          Text(
            title,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[400]),
          ),
          4.h.verticalSpace,
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFinalRankings(BuildContext context, Session session) {
    final teams = [
      {'name': session.team1Name, 'score': session.team1Score},
      {'name': session.team2Name, 'score': session.team2Score},
    ];
    teams.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FINAL RANKINGS',
          style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12.sp),
        ),
        16.h.verticalSpace,
        _buildRankingItem(1, teams[0]['name'] as String, teams[0]['score'] as int, true),
        12.h.verticalSpace,
        _buildRankingItem(2, teams[1]['name'] as String, teams[1]['score'] as int, false),
      ],
    );
  }

  Widget _buildRankingItem(int rank, String name, int score, bool isWinner) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: isWinner ? AppTheme.primary.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Text(
            '#$rank',
            style: TextStyle(fontWeight: FontWeight.bold, color: isWinner ? AppTheme.primary : Colors.grey, fontSize: 14.sp),
          ),
          16.w.horizontalSpace,
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(
            score.toString(),
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 40.r, offset: Offset(0, -10.h))],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                context.read<SessionCubit>().finishSession();
                context.go('/');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: const Text('END SESSION'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share),
              label: const Text('SHARE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
