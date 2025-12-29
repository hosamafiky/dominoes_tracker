import '../repositories/session_repository.dart';

class CompleteSession {
  final SessionRepository repository;

  CompleteSession(this.repository);

  Future<void> call(String sessionId) async {
    await repository.completeSession(sessionId);
  }
}
