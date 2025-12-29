import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final String id;
  final DateTime date;
  final int team1Score;
  final int team2Score;
  final String team1Name;
  final String team2Name;
  final bool isCompleted;

  const Session({
    required this.id,
    required this.date,
    required this.team1Score,
    required this.team2Score,
    this.team1Name = 'Team 1',
    this.team2Name = 'Team 2',
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [id, date, team1Score, team2Score, team1Name, team2Name, isCompleted];
}
