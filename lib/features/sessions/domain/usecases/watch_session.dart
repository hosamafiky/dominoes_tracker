import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/session.dart';
import '../repositories/session_repository.dart';

class WatchSession {
  final SessionRepository repository;

  WatchSession(this.repository);

  Stream<Either<Failure, Session>> call(String sessionId) {
    return repository.watchSession(sessionId);
  }
}
