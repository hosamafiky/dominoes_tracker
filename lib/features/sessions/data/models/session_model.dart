import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/session.dart';

class SessionModel extends Session {
  const SessionModel({
    required super.id,
    required super.date,
    required super.team1Score,
    required super.team2Score,
    super.team1Name = 'Team 1',
    super.team2Name = 'Team 2',
    super.isCompleted = false,
  });

  factory SessionModel.fromFirestore(Map<String, dynamic> json, String id) {
    return SessionModel(
      id: id,
      date: (json['date'] as Timestamp).toDate(),
      team1Score: json['team1Score'] ?? 0,
      team2Score: json['team2Score'] ?? 0,
      team1Name: json['team1Name'] ?? 'Team 1',
      team2Name: json['team2Name'] ?? 'Team 2',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'team1Score': team1Score,
      'team2Score': team2Score,
      'team1Name': team1Name,
      'team2Name': team2Name,
      'isCompleted': isCompleted,
    };
  }
}
