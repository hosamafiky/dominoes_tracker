import 'package:dartz/dartz.dart';

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
        .map<Either<Failure, Session>>((session) {
          return Right(session);
        })
        .handleError((error) {
          return Left(ServerFailure(error.toString()));
        });
  }

  @override
  Future<Either<Failure, String>> startSession(Session session) async {
    try {
      final model = SessionModel.fromEntity(session);
      final id = await remoteDataSource.startSession(model);
      return Right(id);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addRound(String sessionId, String winningTeam, int points) async {
    try {
      await remoteDataSource.addRound(sessionId, {'winningTeamName': winningTeam, 'points': points, 'timestamp': DateTime.now()});
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> completeSession(String sessionId) async {
    try {
      await remoteDataSource.completeSession(sessionId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
