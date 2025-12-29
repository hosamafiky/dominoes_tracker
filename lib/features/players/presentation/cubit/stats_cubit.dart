import 'package:dominoes_tracker/core/enums/usecase_status.dart';
import 'package:dominoes_tracker/core/error/failures.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/player.dart';
import '../../domain/entities/player_stats.dart';
import '../../domain/usecases/get_player.dart';
import '../../domain/usecases/get_player_stats.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final GetPlayerStats getPlayerStats;
  final GetPlayer getPlayer;

  StatsCubit({required this.getPlayerStats, required this.getPlayer}) : super(const StatsState());

  Future<void> loadPlayerStats(String playerId) async {
    emit(state.copyWith(statsStatus: UseCaseStatus.loading));
    final result = await getPlayerStats(playerId);
    result.fold(
      (failure) => emit(state.copyWith(statsStatus: UseCaseStatus.failure, statsFailure: failure)),
      (stats) => emit(state.copyWith(statsStatus: UseCaseStatus.success, stats: stats)),
    );
  }

  Future<void> loadPlayer(String playerId) async {
    emit(state.copyWith(playerStatus: UseCaseStatus.loading));
    final result = await getPlayer(playerId);
    result.fold(
      (failure) => emit(state.copyWith(playerStatus: UseCaseStatus.failure, playerFailure: failure)),
      (player) => emit(state.copyWith(playerStatus: UseCaseStatus.success, player: player)),
    );
  }
}
