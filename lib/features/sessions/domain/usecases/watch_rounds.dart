import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/round.dart';
import '../repositories/session_repository.dart';

class WatchRounds {
  final SessionRepository repository;

  WatchRounds(this.repository);

  Stream<Either<Failure, List<Round>>> call(String sessionId) {
    return repository.watchRounds(sessionId);
  }
}
