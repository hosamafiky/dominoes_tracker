import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/session.dart';
import '../repositories/session_repository.dart';

class StartSession {
  final SessionRepository repository;

  StartSession(this.repository);

  Future<Either<Failure, String>> call(Session params) async {
    return await repository.startSession(params);
  }
}
