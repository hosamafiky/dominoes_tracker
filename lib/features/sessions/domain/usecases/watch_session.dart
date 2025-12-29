import '../entities/session.dart';
import '../repositories/session_repository.dart';

class WatchSession {
  final SessionRepository repository;

  WatchSession(this.repository);

  Stream<Session> call(String sessionId) {
    return repository.watchSession(sessionId);
  }
}
