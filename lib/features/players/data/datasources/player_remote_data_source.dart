import 'package:dominoes_tracker/core/network/firestore_helper.dart';

import '../models/player_model.dart';

abstract class PlayerRemoteDataSource {
  Future<List<PlayerModel>> getPlayers();
  Future<PlayerModel> togglePlayerSelection(String playerId, bool isSelected);
  Future<PlayerModel> addPlayer(PlayerModel player);
  Future<PlayerModel> getPlayerById(String playerId);
}

class PlayerRemoteDataSourceImpl implements PlayerRemoteDataSource {
  final FirestoreHelper helper;

  const PlayerRemoteDataSourceImpl({required this.helper});

  @override
  Future<List<PlayerModel>> getPlayers() async {
    return await helper.getCollection(path: 'players', fromFirestore: (data, id) => PlayerModel.fromFirestore(data, id));
  }

  @override
  Future<PlayerModel> togglePlayerSelection(String playerId, bool isSelected) async {
    return await helper.updateDocument(
      path: 'players/$playerId',
      data: {'isSelected': isSelected},
      fromFirestore: (data, id) => PlayerModel.fromFirestore(data, id),
    );
  }

  @override
  Future<PlayerModel> addPlayer(PlayerModel player) async {
    return await helper.addDocument(path: 'players', data: player.toFirestore(), fromFirestore: (data, id) => PlayerModel.fromFirestore(data, id));
  }

  @override
  Future<PlayerModel> getPlayerById(String playerId) async {
    return await helper.getDocument(path: 'players/$playerId', fromFirestore: (data, id) => PlayerModel.fromFirestore(data, id));
  }
}
