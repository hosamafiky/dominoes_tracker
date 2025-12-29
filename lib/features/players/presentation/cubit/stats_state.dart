part of 'stats_cubit.dart';

class StatsState extends Equatable {
  final UseCaseStatus statsStatus;
  final PlayerStats stats;
  final Failure? statsFailure;

  final UseCaseStatus playerStatus;
  final Player? player;
  final Failure? playerFailure;

  const StatsState({
    this.statsStatus = UseCaseStatus.initial,
    this.stats = const PlayerStats(),
    this.statsFailure,
    this.playerStatus = UseCaseStatus.initial,
    this.player,
    this.playerFailure,
  });

  StatsState copyWith({
    UseCaseStatus? statsStatus,
    PlayerStats? stats,
    Failure? statsFailure,
    UseCaseStatus? playerStatus,
    Player? player,
    Failure? playerFailure,
  }) {
    return StatsState(
      statsStatus: statsStatus ?? this.statsStatus,
      stats: stats ?? this.stats,
      statsFailure: statsFailure ?? this.statsFailure,
      playerStatus: playerStatus ?? this.playerStatus,
      player: player ?? this.player,
      playerFailure: playerFailure ?? this.playerFailure,
    );
  }

  @override
  List<Object?> get props => [statsStatus, stats, statsFailure, playerStatus, player, playerFailure];
}
