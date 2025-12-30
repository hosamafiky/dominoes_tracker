import 'package:dominoes_tracker/features/players/domain/entities/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/enums/usecase_status.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../players/presentation/cubit/players_cubit.dart';
import '../cubit/session_cubit.dart';
import '../widgets/game_mode_segmented_control.dart';
import '../widgets/roster_header.dart';
import '../widgets/session_bottom_nav.dart';
import '../widgets/session_footer.dart';
import '../widgets/session_headline.dart';
import '../widgets/session_settings_card.dart';
import '../widgets/team_roster_grid.dart';

class SessionSetupPage extends StatefulWidget {
  const SessionSetupPage({super.key});

  @override
  State<SessionSetupPage> createState() => _SessionSetupPageState();
}

class _SessionSetupPageState extends State<SessionSetupPage> {
  bool isTeamMode = true;
  int playersPerTeam = 2;
  int scoreLimit = 100;

  List<Player> team1 = [];
  List<Player> team2 = [];

  void _updateRoster(List<Player> players) {
    final allPlayers = players.toList()..shuffle();
    final halfSize = (allPlayers.length / 2).ceil();
    setState(() {
      team1 = allPlayers.take(halfSize).toList();
      team2 = allPlayers.skip(halfSize).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<PlayersCubit>().loadPlayers();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMM d • h:mm a').format(now);

    return MultiBlocListener(
      listeners: [
        BlocListener<SessionCubit, SessionState>(
          listener: (context, state) {
            final route = ModalRoute.of(context)!;
            final isCurrent = route.isCurrent;
            if (!isCurrent) return;
            if (state.sessionStatus == UseCaseStatus.success && state.session != null) {
              context.push('/live-game/${state.session!.id}');
            } else if (state.sessionStatus == UseCaseStatus.failure && state.sessionError != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.sessionError!), backgroundColor: Colors.red));
            }
          },
        ),
        BlocListener<PlayersCubit, PlayersState>(
          listener: (context, state) {
            if (state is PlayersLoaded) {
              _updateRoster(state.players);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          12.verticalSpace,
                          SessionHeadline(dateStr: dateStr),
                          24.verticalSpace,
                          GameModeSegmentedControl(isTeamMode: isTeamMode, onModeChanged: (val) => setState(() => isTeamMode = val)),
                          24.verticalSpace,
                          SessionSettingsCard(
                            playersPerTeam: playersPerTeam,
                            scoreLimit: scoreLimit,
                            onPlayersPerTeamChanged: (val) => setState(() => playersPerTeam = val),
                            onScoreLimitTap: () {
                              //TODO: Show score limit picker
                            },
                          ),
                          24.verticalSpace,
                          RosterHeader(onRandomizeTap: () => _updateRoster(team1..addAll(team2)), onManualTap: () {}),
                          16.verticalSpace,
                          TeamRosterGrid(team1: team1, team2: team2),
                          160.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<SessionCubit, SessionState>(
              builder: (context, state) => SessionFooter(
                sessionStatus: state.sessionStatus,
                onCreateSession: () {
                  context.read<SessionCubit>().createSession(
                    team1Name: isTeamMode ? 'Team A' : 'Player 1',
                    team2Name: isTeamMode ? 'Team B' : 'Player 2',
                    limit: scoreLimit,
                    team1PlayerIds: team1.map((p) => p.id).toList(),
                    team2PlayerIds: team2.map((p) => p.id).toList(),
                  );
                },
              ),
            ),
            SessionBottomNav(currentIndex: 0, onIndexChanged: (index) {}, onPlayersTap: () => context.push('/players')),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconBg = isDark ? Colors.white.withValues(alpha: 0.05) : AppTheme.surfaceHighlight;

    return Padding(
      padding: EdgeInsets.all(16.dg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppIconButton(icon: Icons.arrow_back_ios_new, onTap: () => Navigator.pop(context), backgroundColor: iconBg),
          AppIconButton(icon: Icons.settings_outlined, onTap: () {}, backgroundColor: iconBg),
        ],
      ),
    );
  }
}
