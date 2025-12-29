import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWinnerSection(context, session),
                        const SizedBox(height: 32),
                        _buildMVPSection(context), // Placeholder for now
                        const SizedBox(height: 32),
                        _buildFunStatsSection(context), // Placeholder for now
                        const SizedBox(height: 32),
                        _buildFinalRankings(context, session),
                        const SizedBox(height: 120), // Bottom padding
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
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.backgroundDark], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: const Center(child: Icon(Icons.emoji_events_rounded, size: 80, color: AppTheme.accentGold)),
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
          const Text(
            'WINNER',
            style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            winner,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            '${session.team1Score} - ${session.team2Score}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
          ),
        ],
      ),
    );
  }

  Widget _buildMVPSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MVP OF THE SESSION',
          style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: AppTheme.accentGold,
                child: Icon(Icons.person, size: 40, color: Colors.black),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('John Doe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('45 points contributed', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.workspace_premium, color: AppTheme.accentGold, size: 32),
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
        const Text(
          'FUN STATS',
          style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard('Most Wins', 'Sarah Miller', Icons.trending_up)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('The Brick', 'Mike Ross', Icons.block, color: Colors.red)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String name, IconData icon, {Color color = AppTheme.primary}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
          const SizedBox(height: 4),
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
        const Text(
          'FINAL RANKINGS',
          style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 16),
        _buildRankingItem(1, teams[0]['name'] as String, teams[0]['score'] as int, true),
        const SizedBox(height: 12),
        _buildRankingItem(2, teams[1]['name'] as String, teams[1]['score'] as int, false),
      ],
    );
  }

  Widget _buildRankingItem(int rank, String name, int score, bool isWinner) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: isWinner ? AppTheme.primary.withOpacity(0.3) : Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            '#$rank',
            style: TextStyle(fontWeight: FontWeight.bold, color: isWinner ? AppTheme.primary : Colors.grey),
          ),
          const SizedBox(width: 16),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(score.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundDark,
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 40, offset: Offset(0, -10))],
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
