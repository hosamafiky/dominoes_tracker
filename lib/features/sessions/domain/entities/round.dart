import 'package:equatable/equatable.dart';

class Round extends Equatable {
  final String id;
  final String winningTeamName;
  final int points;
  final DateTime timestamp;

  const Round({required this.id, required this.winningTeamName, required this.points, required this.timestamp});
  @override
  List<Object?> get props => [id, winningTeamName, points, timestamp];
}
