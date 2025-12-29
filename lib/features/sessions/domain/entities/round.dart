import 'package:equatable/equatable.dart';

class Round extends Equatable {
  final String id;
  final String sessionId;
  final String winningTeamName;
  final int points;
  final DateTime timestamp;

  const Round({required this.id, required this.sessionId, required this.winningTeamName, required this.points, required this.timestamp});

  @override
  List<Object?> get props => [id, sessionId, winningTeamName, points, timestamp];
}
