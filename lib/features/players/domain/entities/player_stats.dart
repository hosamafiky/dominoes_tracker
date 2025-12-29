import 'package:equatable/equatable.dart';

class PlayerStats extends Equatable {
  final int totalGames;
  final int wins;
  final int losses;
  final double winRate;
  final int currentStreak;
  final String bestPartner;
  final String nemesis;

  const PlayerStats({
    required this.totalGames,
    required this.wins,
    required this.losses,
    required this.winRate,
    required this.currentStreak,
    required this.bestPartner,
    required this.nemesis,
  });

  @override
  List<Object?> get props => [totalGames, wins, losses, winRate, currentStreak, bestPartner, nemesis];
}
