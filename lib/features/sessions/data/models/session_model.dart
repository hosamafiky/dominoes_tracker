import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/session.dart';

class SessionModel extends Session {
  const SessionModel({
    required super.id,
    required super.date,
    required super.team1Score,
    required super.team2Score,
    required super.limit,
    super.team1Name = 'Team 1',
    super.team2Name = 'Team 2',
    super.isCompleted = false,
    super.team1PlayerIds = const [],
    super.team2PlayerIds = const [],
  });

  factory SessionModel.fromEntity(Session entity) {
    return SessionModel(
      id: entity.id,
      date: entity.date,
      team1Score: entity.team1Score,
      team2Score: entity.team2Score,
      limit: entity.limit,
      team1Name: entity.team1Name,
      team2Name: entity.team2Name,
      isCompleted: entity.isCompleted,
      team1PlayerIds: entity.team1PlayerIds,
      team2PlayerIds: entity.team2PlayerIds,
    );
  }

  factory SessionModel.fromFirestore(Map<String, dynamic> json, String id) {
    return SessionModel(
      id: id,
      date: (json['date'] as Timestamp).toDate(),
      team1Score: json['team1Score'] ?? 0,
      team2Score: json['team2Score'] ?? 0,
      limit: json['limit'] ?? 0,
      team1Name: json['team1Name'] ?? 'Team 1',
      team2Name: json['team2Name'] ?? 'Team 2',
      isCompleted: json['isCompleted'] ?? false,
      team1PlayerIds: List<String>.from(json['team1PlayerIds'] ?? []),
      team2PlayerIds: List<String>.from(json['team2PlayerIds'] ?? []),
    );
  }

  SessionModel copyWith({
    String? id,
    DateTime? date,
    int? limit,
    int? team1Score,
    int? team2Score,
    String? team1Name,
    String? team2Name,
    bool? isCompleted,
    List<String>? team1PlayerIds,
    List<String>? team2PlayerIds,
  }) {
    return SessionModel(
      id: id ?? this.id,
      date: date ?? this.date,
      limit: limit ?? this.limit,
      team1Score: team1Score ?? this.team1Score,
      team2Score: team2Score ?? this.team2Score,
      team1Name: team1Name ?? this.team1Name,
      team2Name: team2Name ?? this.team2Name,
      isCompleted: isCompleted ?? this.isCompleted,
      team1PlayerIds: team1PlayerIds ?? this.team1PlayerIds,
      team2PlayerIds: team2PlayerIds ?? this.team2PlayerIds,
    );
  }

  SessionModel updateScore({required int points, required String winningTeamName}) {
    if (winningTeamName.trim() == team1Name.trim()) {
      return copyWith(team1Score: team1Score + points);
    } else if (winningTeamName.trim() == team2Name.trim()) {
      return copyWith(team2Score: team2Score + points);
    }
    return this;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'team1Score': team1Score,
      'team2Score': team2Score,
      'limit': limit,
      'team1Name': team1Name,
      'team2Name': team2Name,
      'isCompleted': isCompleted,
      'team1PlayerIds': team1PlayerIds,
      'team2PlayerIds': team2PlayerIds,
    };
  }
}
