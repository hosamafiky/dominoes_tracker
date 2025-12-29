import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/player.dart';

abstract class PlayerRepository {
  Future<Either<Failure, List<Player>>> getPlayers();
  Future<Either<Failure, void>> togglePlayerSelection(String playerId);
  Future<Either<Failure, void>> addPlayer(Player player);
  Future<Either<Failure, Player>> getPlayerById(String playerId);
}
