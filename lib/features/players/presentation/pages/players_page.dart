import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../sessions/presentation/widgets/session_bottom_nav.dart';
import '../../domain/entities/player.dart';
import '../cubit/players_cubit.dart';
import '../widgets/player_card.dart';
import '../widgets/player_start_session_action.dart';
import '../widgets/players_header.dart';

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
                const PlayersHeader(),
                Expanded(
                  child: BlocBuilder<PlayersCubit, PlayersState>(
                    builder: (context, state) {
                      final bool isLoading = state is PlayersLoading || state is PlayersInitial;
                      final List<Player> players = isLoading
                          ? List.generate(6, (index) => Player(id: 'loading-$index', name: 'Player Name', isSelected: false))
                          : (state is PlayersLoaded ? state.players : []);

                      if (state is PlayersError) {
                        return Center(child: Text(state.message));
                      }

                      return Skeletonizer(
                        enabled: isLoading,
                        child: RefreshIndicator.adaptive(
                          onRefresh: () => context.read<PlayersCubit>().loadPlayers(),
                          child: ListView.separated(
                            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 160.h),
                            itemCount: players.length,
                            separatorBuilder: (context, index) => 12.verticalSpace,
                            itemBuilder: (context, index) {
                              final player = players[index];
                              return PlayerCard(
                                player: player,
                                onToggle: (val) {
                                  if (isLoading) return;
                                  context.read<PlayersCubit>().toggleSelection(player.id);
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const PlayerStartSessionAction(),
          SessionBottomNav(
            currentIndex: 1,
            onIndexChanged: (index) {
              if (index == 0) Navigator.pop(context);
            },
            onPlayersTap: () {},
          ),
        ],
      ),
    );
  }
}
