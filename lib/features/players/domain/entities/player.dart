import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool isSelected;

  const Player({required this.id, required this.name, this.avatarUrl, this.isSelected = false});

  Player copyWith({String? id, String? name, String? avatarUrl, bool? isSelected}) {
    return Player(id: id ?? this.id, name: name ?? this.name, avatarUrl: avatarUrl ?? this.avatarUrl, isSelected: isSelected ?? this.isSelected);
  }

  @override
  List<Object?> get props => [id, name, avatarUrl, isSelected];
}
