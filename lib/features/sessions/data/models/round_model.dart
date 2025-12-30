import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dominoes_tracker/features/sessions/domain/entities/round.dart';

class RoundModel extends Round {
  const RoundModel({required super.id, required super.winningTeamName, required super.points, required super.timestamp});

  factory RoundModel.fromEntity(Round entity) {
    return RoundModel(id: entity.id, winningTeamName: entity.winningTeamName, points: entity.points, timestamp: entity.timestamp);
  }

  factory RoundModel.fromFirestore(Map<String, dynamic> json, String id) {
    return RoundModel(id: id, winningTeamName: json['winningTeamName'], points: json['points'], timestamp: json['timestamp']);
  }

  Map<String, dynamic> toFirestore() {
    return {'winningTeamName': winningTeamName, 'points': points, 'timestamp': Timestamp.fromDate(timestamp)};
  }
}
