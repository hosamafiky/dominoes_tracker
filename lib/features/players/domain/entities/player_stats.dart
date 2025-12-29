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
    this.totalGames = 0,
    this.wins = 0,
    this.losses = 0,
    this.winRate = 0.0,
    this.currentStreak = 0,
    this.bestPartner = 'Partner Name',
    this.nemesis = 'Nemesis Name',
  });

  @override
  List<Object?> get props => [totalGames, wins, losses, winRate, currentStreak, bestPartner, nemesis];
}
