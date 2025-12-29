import 'package:dominoes_tracker/core/network/firestore_helper.dart';

import '../models/session_model.dart';

abstract class SessionRemoteDataSource {
  Future<int> getTotalSessionsCount();
  Future<List<SessionModel>> getSessionHistory();
  Future<String> startSession(SessionModel session);
  Stream<SessionModel> watchSession(String sessionId);
  Future<void> addRound(String sessionId, Map<String, dynamic> roundData);
  Future<void> updateSessionScore(String sessionId, int team1Score, int team2Score);
  Future<void> completeSession(String sessionId);
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
  Future<String> startSession(SessionModel session) async {
    final sessionId = await helper.addDocument(path: 'sessions', data: session.toFirestore());
    // Increment total sessions count atomically
    try {
      await helper.incrementField(path: 'metadata/global_stats', field: 'totalSessions');
    } catch (e) {
      // If the document doesn't exist, initialize it
      await helper.setDocument(path: 'metadata/global_stats', data: {'totalSessions': 1});
    }
    return sessionId;
  }

  @override
  Stream<SessionModel> watchSession(String sessionId) {
    return helper.watchDocument(path: 'sessions/$sessionId', fromFirestore: (data, id) => SessionModel.fromFirestore(data, id));
  }

  @override
  Future<void> addRound(String sessionId, Map<String, dynamic> roundData) async {
    await helper.addDocument(path: 'sessions/$sessionId/rounds', data: roundData);
  }

  @override
  Future<void> updateSessionScore(String sessionId, int team1Score, int team2Score) async {
    await helper.updateDocument(path: 'sessions/$sessionId', data: {'team1Score': team1Score, 'team2Score': team2Score});
  }

  @override
  Future<void> completeSession(String sessionId) async {
    await helper.updateDocument(path: 'sessions/$sessionId', data: {'isCompleted': true});
  }
}
