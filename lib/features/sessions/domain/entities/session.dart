import 'package:dominoes_tracker/features/sessions/data/models/session_model.dart';
import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final String id;
  final DateTime date;
  final int limit;
  final int team1Score;
  final int team2Score;
  final String team1Name;
  final String team2Name;
  final bool isCompleted;
  final List<String> team1PlayerIds;
  final List<String> team2PlayerIds;

  const Session({
    required this.id,
    required this.date,
    required this.team1Score,
    required this.team2Score,
    required this.limit,
    this.team1Name = 'Team 1',
    this.team2Name = 'Team 2',
    this.isCompleted = false,
    this.team1PlayerIds = const [],
    this.team2PlayerIds = const [],
  });

  factory Session.fromModel(SessionModel model) {
    return Session(
      id: model.id,
      date: model.date,
      limit: model.limit,
      team1Score: model.team1Score,
      team2Score: model.team2Score,
      team1Name: model.team1Name,
      team2Name: model.team2Name,
      isCompleted: model.isCompleted,
      team1PlayerIds: model.team1PlayerIds,
      team2PlayerIds: model.team2PlayerIds,
    );
  }

  @override
  List<Object?> get props => [id, date, team1Score, team2Score, limit, team1Name, team2Name, isCompleted, team1PlayerIds, team2PlayerIds];
}
