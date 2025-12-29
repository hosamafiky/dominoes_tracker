import '../repositories/session_repository.dart';

class AddRound {
  final SessionRepository repository;

  AddRound(this.repository);

  Future<void> call(String sessionId, String winningTeam, int points) async {
    await repository.addRound(sessionId, winningTeam, points);
  }
}
