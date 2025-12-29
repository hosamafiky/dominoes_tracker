import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/players_cubit.dart';
import '../widgets/player_card.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  @override
  void initState() {
    super.initState();
    context.read<PlayersCubit>().loadPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context),
                // Player List
                Expanded(
                  child: BlocBuilder<PlayersCubit, PlayersState>(
                    builder: (context, state) {
                      if (state is PlayersLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is PlayersLoaded) {
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          itemCount: state.players.length + 1, // +1 for the bottom spacer
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            if (index == state.players.length) {
                              return const SizedBox(height: 140); // Spacer for FAB and Bottom Nav
                            }
                            final player = state.players[index];
                            return PlayerCard(
                              player: player,
                              onToggle: (val) {
                                context.read<PlayersCubit>().toggleSelection(player.id);
                              },
                            );
                          },
                        );
                      } else if (state is PlayersError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
          // Sticky Bottom Actions
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
        border: Border(bottom: BorderSide(color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              BlocBuilder<PlayersCubit, PlayersState>(
                builder: (context, state) {
                  int count = 0;
                  if (state is PlayersLoaded) count = state.selectedCount;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                    ),
                    child: Text(
                      '$count SELECTED',
                      style: const TextStyle(color: AppTheme.primary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Who's Playing?",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.textDark),
          ),
          const SizedBox(height: 4),
          Text(
            "Pick who is joining the table today.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? Colors.grey[400] : Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 40, offset: const Offset(0, -10))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => context.push('/session-setup'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.backgroundDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('START SESSION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_buildNavItem(Icons.history, 'Sessions', false), _buildNavItem(Icons.group, 'Players', true)],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? AppTheme.primary : Colors.grey[500], size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: isActive ? AppTheme.primary : Colors.grey[500], fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.w500),
        ),
      ],
    );
  }
}
