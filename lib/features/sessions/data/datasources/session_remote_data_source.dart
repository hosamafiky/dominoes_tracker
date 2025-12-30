import 'package:dominoes_tracker/core/network/firestore_helper.dart';

import '../models/round_model.dart';
import '../models/session_model.dart';

abstract class SessionRemoteDataSource {
  Future<int> getTotalSessionsCount();
  Future<List<SessionModel>> getSessionHistory();
  Future<SessionModel> startSession(SessionModel session);
  Stream<SessionModel> watchSession(String sessionId);
  Stream<List<RoundModel>> watchRounds(String sessionId);
  Future<RoundModel> addRound(String sessionId, Map<String, dynamic> roundData);
  Future<SessionModel> updateSessionScore(String sessionId, int team1Score, int team2Score);
  Future<SessionModel> completeSession(String sessionId);
}

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  final FirestoreHelper helper;

  SessionRemoteDataSourceImpl({required this.helper});

  @override
  Future<int> getTotalSessionsCount() async {
    return (await helper.count(path: 'sessions')).toInt();
  }

  @override
  Future<List<SessionModel>> getSessionHistory() async {
    return await helper.getCollection(
      path: 'sessions',
      fromFirestore: (data, id) => SessionModel.fromFirestore(data, id),
      queryBuilder: (query) => query.orderBy('date', descending: true),
    );
  }

  @override
  Future<SessionModel> startSession(SessionModel session) async {
    final newSession = await helper.addDocument(
      path: 'sessions',
      data: session.toFirestore(),
      fromFirestore: (data, id) => SessionModel.fromFirestore(data, id),
    );
    // Increment total sessions count atomically
    try {
      await helper.incrementField(path: 'metadata/global_stats', field: 'totalSessions');
    } catch (e) {
      // If the document doesn't exist, initialize it
      await helper.setDocument(path: 'metadata/global_stats', data: {'totalSessions': 1});
    }
    return newSession;
  }

  @override
  Stream<SessionModel> watchSession(String sessionId) {
    return helper.watchDocument(path: 'sessions/$sessionId', fromFirestore: (data, id) => SessionModel.fromFirestore(data, id));
  }

  @override
  Stream<List<RoundModel>> watchRounds(String sessionId) {
    return helper.watchCollection(
      path: 'sessions/$sessionId/rounds',
      fromFirestore: (data, id) => RoundModel.fromFirestore(data, id),
      queryBuilder: (query) => query.orderBy('timestamp', descending: true),
    );
  }

  @override
  Future<RoundModel> addRound(String sessionId, Map<String, dynamic> roundData) async {
    final sessionRef = helper.firestore.doc('sessions/$sessionId');
    final roundRef = helper.firestore.collection('sessions/$sessionId/rounds').doc();

    return await helper.firestore.runTransaction((transaction) async {
      final sessionSnapshot = await transaction.get(sessionRef);
      if (!sessionSnapshot.exists) {
        throw Exception('Session $sessionId not found');
      }

      final session = SessionModel.fromFirestore(sessionSnapshot.data()!, sessionSnapshot.id);
      final updatedSession = session.updateScore(points: roundData['points'], winningTeamName: roundData['winningTeamName']);

      // Ensure that we are actually updating something. If score didn't change (e.g. wrong team name), log it (or throwing error might be better for debugging)
      // For now, consistent behavior: write the new round and update session (even if scores are same).

      transaction.set(roundRef, roundData);
      transaction.update(sessionRef, {'team1Score': updatedSession.team1Score, 'team2Score': updatedSession.team2Score});

      return RoundModel.fromFirestore(roundData, roundRef.id);
    });
  }

  @override
  Future<SessionModel> updateSessionScore(String sessionId, int team1Score, int team2Score) async {
    return await helper.updateDocument(
      path: 'sessions/$sessionId',
      data: {'team1Score': team1Score, 'team2Score': team2Score},
      fromFirestore: (data, id) => SessionModel.fromFirestore(data, id),
    );
  }

  @override
  Future<SessionModel> completeSession(String sessionId) async {
    return await helper.updateDocument(
      path: 'sessions/$sessionId',
      data: {'isCompleted': true},
      fromFirestore: (data, id) => SessionModel.fromFirestore(data, id),
    );
  }
}
