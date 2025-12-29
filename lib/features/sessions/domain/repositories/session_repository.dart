import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/session.dart';

abstract class SessionRepository {
  Future<Either<Failure, int>> getTotalSessionsCount();
  Future<Either<Failure, List<Session>>> getSessionHistory();
  Stream<Either<Failure, Session>> watchSession(String sessionId);
  Future<Either<Failure, String>> startSession(Session session);
  Future<Either<Failure, void>> addRound(String sessionId, String winningTeam, int points);
  Future<Either<Failure, void>> completeSession(String sessionId);
}
