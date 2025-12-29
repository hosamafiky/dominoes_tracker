import 'package:dominoes_tracker/core/network/firestore_helper.dart';

import '../models/player_model.dart';

abstract class PlayerRemoteDataSource {
  Future<List<PlayerModel>> getPlayers();
  Future<void> togglePlayerSelection(String playerId, bool isSelected);
  Future<void> addPlayer(PlayerModel player);
}

class PlayerRemoteDataSourceImpl implements PlayerRemoteDataSource {
  final FirestoreHelper helper;

  PlayerRemoteDataSourceImpl({required this.helper});

  @override
  Future<List<PlayerModel>> getPlayers() async {
    return await helper.getCollection(path: 'players', fromFirestore: (data, id) => PlayerModel.fromFirestore(data, id));
  }

  @override
  Future<void> togglePlayerSelection(String playerId, bool isSelected) async {
    await helper.updateDocument(path: 'players/$playerId', data: {'isSelected': isSelected});
  }

  @override
  Future<void> addPlayer(PlayerModel player) async {
    await helper.addDocument(path: 'players', data: player.toFirestore());
  }
}
