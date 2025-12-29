import '../../domain/entities/player.dart';

class PlayerModel extends Player {
  const PlayerModel({required super.id, required super.name, super.avatarUrl, super.isSelected = false, super.isActive = true});

  factory PlayerModel.fromFirestore(Map<String, dynamic> json, String id) {
    return PlayerModel(
      id: id,
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'],
      isSelected: json['isSelected'] ?? false,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'avatarUrl': avatarUrl, 'isSelected': isSelected, 'isActive': isActive};
  }
}
