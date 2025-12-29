import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
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
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
            if (state.history.isEmpty) {
              return const Center(child: Text('No sessions yet. Start a game!'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: state.history.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final session = state.history[index];
                final dateStr = '${session.date.day}/${session.date.month}/${session.date.year}';
                final winner = session.team1Score >= session.team2Score ? session.team1Name : session.team2Name;
                final score = '${session.team1Score} - ${session.team2Score}';
                return _buildHistoryCard(context, '${session.team1Name} vs ${session.team2Name}', dateStr, winner, score);
              },
            );
          } else if (state is HistoryError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          }
          return const Center(child: Text('Initializing history...'));
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, String title, String date, String winner, String score) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: !isDark ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: const Text(
                  'COMPLETED',
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(children: [_buildSimpleStat('Winner', winner), const Spacer(), _buildSimpleStat('Final Score', score, isPrimary: true)]),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(String label, String value, {bool isPrimary = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: isPrimary ? AppTheme.accentGold : Colors.white),
        ),
      ],
    );
  }
}
