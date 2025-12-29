import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_remote_data_source.dart';
import '../models/session_model.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remoteDataSource;

  SessionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<int> getTotalSessionsCount() async {
    return await remoteDataSource.getTotalSessionsCount();
  }

  @override
  Future<List<Session>> getSessionHistory() async {
    return await remoteDataSource.getSessionHistory();
  }

  @override
  Stream<Session> watchSession(String sessionId) {
    return remoteDataSource.watchSession(sessionId);
  }

  @override
  Future<String> startSession(Session session) async {
    final model = SessionModel(
      id: session.id,
      date: session.date,
      team1Score: session.team1Score,
      team2Score: session.team2Score,
      team1Name: session.team1Name,
      team2Name: session.team2Name,
      isCompleted: session.isCompleted,
    );
    return await remoteDataSource.startSession(model);
  }

  @override
  Future<void> addRound(String sessionId, String winningTeam, int points) async {
    await remoteDataSource.addRound(sessionId, {'winningTeamName': winningTeam, 'points': points, 'timestamp': DateTime.now()});
  }

  @override
  Future<void> completeSession(String sessionId) async {
    await remoteDataSource.completeSession(sessionId);
  }
}
