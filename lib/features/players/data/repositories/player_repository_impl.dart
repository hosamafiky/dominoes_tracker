import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/player.dart';
import '../../domain/repositories/player_repository.dart';
import '../datasources/player_remote_data_source.dart';
import '../models/player_model.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerRemoteDataSource remoteDataSource;

  PlayerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Player>>> getPlayers() async {
    try {
      final models = await remoteDataSource.getPlayers();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> togglePlayerSelection(String playerId) async {
    try {
      final players = await remoteDataSource.getPlayers();
      final player = players.firstWhere((p) => p.id == playerId);
      await remoteDataSource.togglePlayerSelection(playerId, !player.isSelected);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addPlayer(Player player) async {
    try {
      final model = PlayerModel(id: player.id, name: player.name, avatarUrl: player.avatarUrl, isSelected: player.isSelected);
      await remoteDataSource.addPlayer(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Player>> getPlayerById(String playerId) async {
    try {
      final model = await remoteDataSource.getPlayerById(playerId);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
