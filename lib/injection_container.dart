import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dominoes_tracker/core/network/firestore_helper.dart';
import 'package:dominoes_tracker/features/players/domain/usecases/get_player.dart';
import 'package:get_it/get_it.dart';

import 'features/history/presentation/cubit/history_cubit.dart';
import 'features/players/data/datasources/player_remote_data_source.dart';
import 'features/players/data/repositories/player_repository_impl.dart';
import 'features/players/domain/repositories/player_repository.dart';
import 'features/players/domain/usecases/add_player.dart';
import 'features/players/domain/usecases/get_player_stats.dart';
import 'features/players/domain/usecases/get_players.dart';
import 'features/players/domain/usecases/toggle_player_selection.dart';
import 'features/players/presentation/cubit/players_cubit.dart';
import 'features/players/presentation/cubit/stats_cubit.dart';
import 'features/sessions/data/datasources/session_remote_data_source.dart';
import 'features/sessions/data/repositories/session_repository_impl.dart';
import 'features/sessions/domain/repositories/session_repository.dart';
import 'features/sessions/domain/usecases/add_round.dart';
import 'features/sessions/domain/usecases/complete_session.dart';
import 'features/sessions/domain/usecases/get_total_sessions.dart';
import 'features/sessions/domain/usecases/start_session.dart';
import 'features/sessions/domain/usecases/watch_rounds.dart';
import 'features/sessions/domain/usecases/watch_session.dart';
import 'features/sessions/presentation/cubit/session_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Splash

  // Cubit
  sl.registerFactory(
    () => SessionCubit(
      getTotalSessionsUseCase: sl(),
      startSessionUseCase: sl(),
      addRoundUseCase: sl(),
      watchSessionUseCase: sl(),
      watchRoundsUseCase: sl(),
      completeSessionUseCase: sl(),
      getPlayersUseCase: sl(),
      addPlayerUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTotalSessions(sl()));
  sl.registerLazySingleton(() => StartSession(sl()));
  sl.registerLazySingleton(() => AddRound(sl()));
  sl.registerLazySingleton(() => WatchSession(sl()));
  sl.registerLazySingleton(() => WatchRounds(sl()));
  sl.registerLazySingleton(() => CompleteSession(sl()));

  // Repository
  sl.registerLazySingleton<SessionRepository>(() => SessionRepositoryImpl(remoteDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<SessionRemoteDataSource>(() => SessionRemoteDataSourceImpl(helper: sl()));

  // Features - Players

  // Cubit
  sl.registerFactory(() => PlayersCubit(getPlayers: sl(), togglePlayerSelection: sl()));
  sl.registerFactory(() => HistoryCubit(repository: sl()));
  sl.registerFactory(() => StatsCubit(getPlayer: sl(), getPlayerStats: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetPlayers(sl()));
  sl.registerLazySingleton(() => GetPlayer(sl()));
  sl.registerLazySingleton(() => TogglePlayerSelection(sl()));
  sl.registerLazySingleton(() => AddPlayer(sl()));
  sl.registerLazySingleton(() => GetPlayerStats(sessionRepository: sl(), playerRepository: sl()));

  // Repository
  sl.registerLazySingleton<PlayerRepository>(() => PlayerRepositoryImpl(remoteDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<PlayerRemoteDataSource>(() => PlayerRemoteDataSourceImpl(helper: sl()));

  // Core
  // e.g. sl.registerLazySingleton(() => NetworkInfo(sl()));

  // External
  final firestore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => firestore);
  sl.registerLazySingleton(() => FirestoreHelper(firestore: sl()));
}
