import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/player_repository.dart';
import '../entities/player.dart';

class GetPlayer {
  final PlayerRepository playerRepository;

  GetPlayer(this.playerRepository);

  Future<Either<Failure, Player>> call(String playerId) async {
    return await playerRepository.getPlayerById(playerId);
  }
}
