import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/session_repository.dart';

class GetTotalSessions {
  final SessionRepository repository;

  GetTotalSessions(this.repository);

  Future<Either<Failure, int>> call() async {
    return await repository.getTotalSessionsCount();
  }
}
