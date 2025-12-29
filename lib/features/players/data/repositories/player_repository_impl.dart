import '../../domain/entities/player.dart';
import '../../domain/repositories/player_repository.dart';
import '../datasources/player_remote_data_source.dart';
import '../models/player_model.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerRemoteDataSource remoteDataSource;

  PlayerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Player>> getPlayers() async {
    return await remoteDataSource.getPlayers();
  }

  @override
  Future<void> togglePlayerSelection(String playerId) async {
    final players = await remoteDataSource.getPlayers();
    final player = players.firstWhere((p) => p.id == playerId);
    await remoteDataSource.togglePlayerSelection(playerId, !player.isSelected);
  }

  @override
  Future<void> addPlayer(Player player) async {
    final model = PlayerModel(id: player.id, name: player.name, avatarUrl: player.avatarUrl, isSelected: player.isSelected, isActive: player.isActive);
    await remoteDataSource.addPlayer(model);
  }
}
