import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/usecase_status.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/session.dart';
import '../cubit/session_cubit.dart';

class LiveGamePage extends StatelessWidget {
  const LiveGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: isDark ? Colors.white : AppTheme.textDark),
        ),
        title: Text(
          'Live Session',
          style: TextStyle(color: isDark ? Colors.white : AppTheme.textDark, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: isDark ? Colors.white : AppTheme.textDark),
          ),
        ],
      ),
      body: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, state) {
          if (state.sessionStatus == UseCaseStatus.initial || state.sessionStatus == UseCaseStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.sessionStatus == UseCaseStatus.success && state.session != null) {
            final session = state.session!;
            return Column(
              children: [
                _buildScoreboard(context, session),
                const SizedBox(height: 24),
                _buildMatchTitle(context, session),
                const SizedBox(height: 16),
                Expanded(child: _buildGameHistory(context, session)),
                _buildAddRoundButton(context, session),
              ],
            );
          } else if (state.sessionStatus == UseCaseStatus.failure && state.sessionError != null) {
            return Center(
              child: Text(state.sessionError!, style: const TextStyle(color: Colors.red)),
            );
          }
          return const Center(child: Text('Initializing session...'));
        },
      ),
    );
  }

  Widget _buildScoreboard(BuildContext context, Session session) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTeamScore(session.team1Name, session.team1Score, session.team1Score >= session.team2Score),
          Container(height: 60, width: 1, color: AppTheme.primary.withOpacity(0.2)),
          _buildTeamScore(session.team2Name, session.team2Score, session.team2Score > session.team1Score),
        ],
      ),
    );
  }

  Widget _buildTeamScore(String name, int score, bool isLeading) {
    return Column(
      children: [
        if (isLeading)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: AppTheme.accentGold, borderRadius: BorderRadius.circular(4)),
            child: const Text(
              'LEADING',
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          )
        else
          const SizedBox(height: 12),
        const SizedBox(height: 8),
        Text(
          score.toString(),
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        Text(
          name,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildMatchTitle(BuildContext context, Session session) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Game History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(
            'Limit: 100 pts', // This should eventually come from game settings
            style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildGameHistory(BuildContext context, Session session) {
    // Round history should ideally be a separate stream or collection
    // For now, we'll keep it simple or show a placeholder if we haven't implemented round list fetching
    return Center(
      child: Text('Round details appearing soon...', style: TextStyle(color: Colors.grey[600])),
    );
  }

  Widget _buildAddRoundButton(BuildContext context, Session session) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              onPressed: () => _showAddResult(context, session),
              icon: const Icon(Icons.add_circle, size: 24),
              label: const Text('RECORD RESULT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.push('/session-summary/${session.id}'),
            child: Text(
              'FINISH SESSION',
              style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddResult(BuildContext context, Session session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<SessionCubit>(),
        child: AddResultBottomSheet(session: session),
      ),
    );
  }
}

class AddResultBottomSheet extends StatefulWidget {
  final Session session;
  const AddResultBottomSheet({super.key, required this.session});

  @override
  State<AddResultBottomSheet> createState() => _AddResultBottomSheetState();
}

class _AddResultBottomSheetState extends State<AddResultBottomSheet> {
  String? winningTeamId;
  String pointsStr = '0';

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'Del') {
        if (pointsStr.length > 1) {
          pointsStr = pointsStr.substring(0, pointsStr.length - 1);
        } else {
          pointsStr = '0';
        }
      } else {
        if (pointsStr == '0') {
          pointsStr = key;
        } else {
          pointsStr += key;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Record Result', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'WHO WON?',
            style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => winningTeamId = widget.session.team1Name),
                  child: _buildWinnerCard(widget.session.team1Name, winningTeamId == widget.session.team1Name),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => winningTeamId = widget.session.team2Name),
                  child: _buildWinnerCard(widget.session.team2Name, winningTeamId == widget.session.team2Name),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'ENTER POINTS',
            style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(pointsStr, style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 24),
          _buildKeypad(),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: winningTeamId == null || pointsStr == '0'
                  ? null
                  : () {
                      context.read<SessionCubit>().recordRound(winningTeamId!, int.parse(pointsStr));
                      Navigator.pop(context);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              ),
              child: const Text('SAVE ROUND', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWinnerCard(String name, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? AppTheme.primary : Colors.grey.withOpacity(0.3)),
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppTheme.primary : Colors.grey),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'Del'].map((key) => _buildKeypadButton(key)).toList(),
    );
  }

  Widget _buildKeypadButton(String label) {
    final isAction = label == 'Del';
    return GestureDetector(
      onTap: () => _onKeyPress(label),
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(color: isAction ? Colors.red.withOpacity(0.1) : Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isAction ? Colors.red : Colors.white),
          ),
        ),
      ),
    );
  }
}
