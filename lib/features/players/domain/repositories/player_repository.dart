import '../entities/player.dart';

abstract class PlayerRepository {
  Future<List<Player>> getPlayers();
  Future<void> togglePlayerSelection(String playerId);
  Future<void> addPlayer(Player player);
}
