import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/player.dart';
import '../repositories/player_repository.dart';

class GetPlayers {
  final PlayerRepository repository;

  GetPlayers(this.repository);

  Future<Either<Failure, List<Player>>> call() async {
    return await repository.getPlayers();
  }
}
