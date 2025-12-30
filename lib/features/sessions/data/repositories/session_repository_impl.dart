import 'package:dartz/dartz.dart';
import 'package:dominoes_tracker/features/sessions/domain/entities/round.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_remote_data_source.dart';
import '../models/session_model.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remoteDataSource;

  SessionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, int>> getTotalSessionsCount() async {
    try {
      final count = await remoteDataSource.getTotalSessionsCount();
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Session>>> getSessionHistory() async {
    try {
      final models = await remoteDataSource.getSessionHistory();
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, Session>> watchSession(String sessionId) {
    return remoteDataSource
        .watchSession(sessionId)
        .map<Either<Failure, Session>>((session) => Right(session))
        .handleError((error) => Left(ServerFailure(error.toString())));
  }

  @override
  Stream<Either<Failure, List<Round>>> watchRounds(String sessionId) {
    return remoteDataSource
        .watchRounds(sessionId)
        .map<Either<Failure, List<Round>>>((rounds) => Right(rounds))
        .handleError((error) => Left(ServerFailure(error.toString())));
  }

  @override
  Future<Either<Failure, Session>> startSession(Session session) async {
    try {
      final model = SessionModel.fromEntity(session);
      final newSession = await remoteDataSource.startSession(model);
      return Right(newSession);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Round>> addRound(String sessionId, String winningTeam, int points) async {
    try {
      final round = await remoteDataSource.addRound(sessionId, {'winningTeamName': winningTeam, 'points': points, 'timestamp': DateTime.now()});
      return Right(round);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Session>> completeSession(String sessionId) async {
    try {
      final session = await remoteDataSource.completeSession(sessionId);
      return Right(session);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
