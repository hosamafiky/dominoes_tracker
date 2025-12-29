import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/player.dart';
import '../repositories/player_repository.dart';

class AddPlayer {
  final PlayerRepository repository;

  AddPlayer(this.repository);

  Future<Either<Failure, void>> call(Player params) async {
    return await repository.addPlayer(params);
  }
}
