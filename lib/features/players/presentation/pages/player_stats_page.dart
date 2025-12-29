import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/player_stats.dart';
import '../cubit/stats_cubit.dart';

class PlayerStatsPage extends StatelessWidget {
  const PlayerStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Stats', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<StatsCubit, StatsState>(
        builder: (context, state) {
          if (state is StatsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StatsLoaded) {
            final stats = state.stats;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildProfileHeader(context),
                  const SizedBox(height: 32),
                  _buildWinRateSection(context, stats.winRate),
                  const SizedBox(height: 32),
                  _buildStatsGrid(context, stats),
                  const SizedBox(height: 32),
                  _buildInsightsSection(context, stats),
                ],
              ),
            );
          } else if (state is StatsError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          }
          return const Center(child: Text('Initializing stats...'));
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primary,
              child: Icon(Icons.person, size: 60, color: Colors.black),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: AppTheme.accentGold, shape: BoxShape.circle),
              child: const Icon(Icons.star, size: 20, color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Uncle Tony', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(
          'Pro Player • Since 2023',
          style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildWinRateSection(BuildContext context, double winRate) {
    final winRatePct = (winRate * 100).toInt();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: winRate,
                  strokeWidth: 8,
                  backgroundColor: Colors.white10,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),
              ),
              Text('$winRatePct%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 24),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WIN RATE',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppTheme.primary),
              ),
              SizedBox(height: 4),
              Text('Consistently winning!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, PlayerStats stats) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatBox('Wins', stats.wins.toString(), AppTheme.primary),
        _buildStatBox('Losses', stats.losses.toString(), Colors.red),
        _buildStatBox('Streak', stats.currentStreak.toString(), AppTheme.accentGold),
      ],
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildInsightsSection(BuildContext context, PlayerStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INSIGHTS',
          style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 16),
        _buildInsightItem('Best Partner', stats.bestPartner, 'Higher win rate together', Icons.favorite),
        const SizedBox(height: 12),
        _buildInsightItem('Nemesis', stats.nemesis, 'Hardest to beat', Icons.bolt),
      ],
    );
  }

  Widget _buildInsightItem(String label, String value, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary.withOpacity(0.8)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          Text(description, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
