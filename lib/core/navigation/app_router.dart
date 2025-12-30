import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../injection_container.dart' as di;
import '../../features/history/presentation/cubit/history_cubit.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/players/presentation/cubit/players_cubit.dart';
import '../../features/players/presentation/cubit/stats_cubit.dart';
import '../../features/players/presentation/pages/player_stats_page.dart';
import '../../features/players/presentation/pages/players_page.dart';
import '../../features/sessions/presentation/cubit/session_cubit.dart';
import '../../features/sessions/presentation/pages/live_game_page.dart';
import '../../features/sessions/presentation/pages/session_setup_page.dart';
import '../../features/sessions/presentation/pages/session_summary_page.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(create: (context) => di.sl<SessionCubit>()..loadSessionsCount(), child: const SplashScreen()),
      ),
      GoRoute(
        path: '/players',
        builder: (context, state) => BlocProvider(create: (context) => di.sl<PlayersCubit>(), child: const PlayersPage()),
      ),
      GoRoute(
        path: '/player-stats/:playerId',
        builder: (context, state) {
          final playerID = state.pathParameters['playerId']!.substring(1);
          return BlocProvider(
            create: (context) => di.sl<StatsCubit>()
              ..loadPlayer(playerID)
              ..loadPlayerStats(playerID),
            child: const PlayerStatsPage(),
          );
        },
      ),
      GoRoute(
        path: '/session-setup',
        builder: (context, state) => BlocProvider(create: (context) => di.sl<SessionCubit>(), child: const SessionSetupPage()),
      ),
      GoRoute(
        path: '/live-game/:sessionId',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return BlocProvider(create: (context) => di.sl<SessionCubit>()..watchSession(sessionId), child: const LiveGamePage());
        },
      ),
      GoRoute(
        path: '/session-summary/:sessionId',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return BlocProvider(create: (context) => di.sl<SessionCubit>()..watchSession(sessionId), child: const SessionSummaryPage());
        },
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => BlocProvider(create: (context) => di.sl<HistoryCubit>()..fetchHistory(), child: const HistoryPage()),
      ),
    ],
  );
}
