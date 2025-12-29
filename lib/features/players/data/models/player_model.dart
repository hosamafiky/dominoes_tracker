import '../../domain/entities/player.dart';

class PlayerModel extends Player {
  const PlayerModel({required super.id, required super.name, super.avatarUrl, super.isSelected = false});

  factory PlayerModel.fromFirestore(Map<String, dynamic> json, String id) {
    return PlayerModel(id: id, name: json['name'] ?? '', avatarUrl: json['avatarUrl'], isSelected: json['isSelected'] ?? false);
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'avatarUrl': avatarUrl, 'isSelected': isSelected};
  }

  Player toEntity() {
    return Player(id: id, name: name, avatarUrl: avatarUrl, isSelected: isSelected);
  }
}
