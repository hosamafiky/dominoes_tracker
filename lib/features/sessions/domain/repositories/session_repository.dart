import 'package:dartz/dartz.dart';
import 'package:dominoes_tracker/features/sessions/domain/entities/round.dart';

import '../../../../core/error/failures.dart';
import '../entities/session.dart';

abstract class SessionRepository {
  Future<Either<Failure, int>> getTotalSessionsCount();
  Future<Either<Failure, List<Session>>> getSessionHistory();
  Stream<Either<Failure, Session>> watchSession(String sessionId);
  Stream<Either<Failure, List<Round>>> watchRounds(String sessionId);
  Future<Either<Failure, Session>> startSession(Session session);
  Future<Either<Failure, Round>> addRound(String sessionId, String winningTeam, int points);
  Future<Either<Failure, Session>> completeSession(String sessionId);
}
