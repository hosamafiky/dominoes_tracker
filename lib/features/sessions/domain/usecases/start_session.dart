import '../entities/session.dart';
import '../repositories/session_repository.dart';

class StartSession {
  final SessionRepository repository;

  StartSession(this.repository);

  Future<String> call(Session session) async {
    return await repository.startSession(session);
  }
}
