import 'package:dartz/dartz.dart';
import 'package:dominoes_tracker/features/sessions/domain/entities/round.dart';

import '../../../../core/error/failures.dart';
import '../repositories/session_repository.dart';

class AddRound {
  final SessionRepository repository;

  AddRound(this.repository);

  Future<Either<Failure, Round>> call(String sessionId, String winningTeam, int points) async {
    return await repository.addRound(sessionId, winningTeam, points);
  }
}
