import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/session_repository.dart';

class CompleteSession {
  final SessionRepository repository;

  CompleteSession(this.repository);

  Future<Either<Failure, void>> call(String sessionId) async {
    return await repository.completeSession(sessionId);
  }
}
