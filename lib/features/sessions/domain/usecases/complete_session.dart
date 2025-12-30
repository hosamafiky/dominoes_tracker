import 'package:dartz/dartz.dart';
import 'package:dominoes_tracker/features/sessions/domain/entities/session.dart';

import '../../../../core/error/failures.dart';
import '../repositories/session_repository.dart';

class CompleteSession {
  final SessionRepository repository;

  CompleteSession(this.repository);

  Future<Either<Failure, Session>> call(String sessionId) async {
    return await repository.completeSession(sessionId);
  }
}
