import '../entities/session.dart';

abstract class SessionRepository {
  Future<int> getTotalSessionsCount();
  Future<List<Session>> getSessionHistory();
  Stream<Session> watchSession(String sessionId);
  Future<String> startSession(Session session);
  Future<void> addRound(String sessionId, String winningTeam, int points);
  Future<void> completeSession(String sessionId);
}
