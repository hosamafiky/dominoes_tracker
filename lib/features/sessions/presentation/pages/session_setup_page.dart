import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Assuming this import is also needed for BlocListener
import 'package:go_router/go_router.dart';

import '../../../../core/enums/usecase_status.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/session_cubit.dart';

class SessionSetupPage extends StatefulWidget {
  const SessionSetupPage({super.key});

  @override
  State<SessionSetupPage> createState() => _SessionSetupPageState();
}

class _SessionSetupPageState extends State<SessionSetupPage> {
  bool isTeamMode = true;
  int playersPerTeam = 2;
  int scoreLimit = 100;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<SessionCubit, SessionState>(
      listener: (context, state) {
        if (state.sessionStatus == UseCaseStatus.success && state.session != null) {
          context.push('/live-game/${state.session!.id}');
        } else if (state.sessionStatus == UseCaseStatus.failure && state.sessionError != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.sessionError!), backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'New Session',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.textDark),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildSectionTitle('GAME MODE'),
                    const SizedBox(height: 12),
                    _buildGameModeToggle(),
                    const SizedBox(height: 24),

                    _buildSectionTitle('TEAM SETTINGS'),
                    const SizedBox(height: 12),
                    _buildPlayersPerTeam(),
                    const SizedBox(height: 16),
                    _buildRandomizeButton(),
                    const SizedBox(height: 24),

                    _buildSectionTitle('RULES'),
                    const SizedBox(height: 12),
                    _buildScoreLimitDropdown(),
                    const SizedBox(height: 32),

                    _buildSectionTitle('CURRENT PLAYERS'),
                    const SizedBox(height: 12),
                    _buildSelectedPlayersPreview(),
                  ],
                ),
              ),

              _buildStartButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
    );
  }

  Widget _buildGameModeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(child: _buildToggleItem('Individual', !isTeamMode, () => setState(() => isTeamMode = false))),
          Expanded(child: _buildToggleItem('Teams', isTeamMode, () => setState(() => isTeamMode = true))),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: isActive ? AppTheme.primary : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: isActive ? Colors.black : Colors.grey[600], fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayersPerTeam() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Players per Team', style: TextStyle(fontWeight: FontWeight.w600)),
        Row(
          children: [
            _buildCircleButton(Icons.remove, () {
              if (playersPerTeam > 1) setState(() => playersPerTeam--);
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('$playersPerTeam', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _buildCircleButton(Icons.add, () {
              if (playersPerTeam < 4) setState(() => playersPerTeam++);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _buildRandomizeButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.shuffle, size: 18),
      label: const Text('Randomize Teams'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.primary,
        side: const BorderSide(color: AppTheme.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildScoreLimitDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: scoreLimit,
          isExpanded: true,
          items: [100, 200, 500].map((int val) {
            return DropdownMenuItem<int>(value: val, child: Text('Score Limit: $val points'));
          }).toList(),
          onChanged: (val) {
            if (val != null) setState(() => scoreLimit = val);
          },
        ),
      ),
    );
  }

  Widget _buildSelectedPlayersPreview() {
    // This would ideally come from the PlayersCubit
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
            child: const Center(child: Icon(Icons.person, color: Colors.white)),
          );
        },
      ),
    );
  }

  Widget _buildStartButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: BlocBuilder<SessionCubit, SessionState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state.sessionStatus == UseCaseStatus.loading
                  ? null
                  : () {
                      context.read<SessionCubit>().createSession(
                        team1Name: isTeamMode ? 'Team A' : 'Player 1',
                        team2Name: isTeamMode ? 'Team B' : 'Player 2',
                        limit: scoreLimit,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              ),
              child: state.sessionStatus == UseCaseStatus.loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                  : const Text('START SESSION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            );
          },
        ),
      ),
    );
  }
}
