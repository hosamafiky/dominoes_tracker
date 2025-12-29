import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/player.dart';
import '../../domain/usecases/get_players.dart';
import '../../domain/usecases/toggle_player_selection.dart';

abstract class PlayersState extends Equatable {
  const PlayersState();
  @override
  List<Object?> get props => [];
}

class PlayersInitial extends PlayersState {}

class PlayersLoading extends PlayersState {}

class PlayersLoaded extends PlayersState {
  final List<Player> players;
  final int selectedCount;

  const PlayersLoaded({required this.players, required this.selectedCount});

  @override
  List<Object?> get props => [players, selectedCount];
}

class PlayersError extends PlayersState {
  final String message;
  const PlayersError(this.message);
  @override
  List<Object?> get props => [message];
}

class PlayersCubit extends Cubit<PlayersState> {
  final GetPlayers getPlayers;
  final TogglePlayerSelection togglePlayerSelection;

  PlayersCubit({required this.getPlayers, required this.togglePlayerSelection}) : super(PlayersInitial());

  Future<void> loadPlayers() async {
    emit(PlayersLoading());
    final result = await getPlayers();
    result.fold((failure) => emit(PlayersError(failure.message)), (players) => _emitLoaded(players));
  }

  Future<void> toggleSelection(String playerId) async {
    if (state is PlayersLoaded) {
      final result = await togglePlayerSelection(playerId);
      result.fold(
        (failure) => emit(PlayersError(failure.message)),
        (_) => loadPlayers(), // Reload to get consistent state
      );
    }
  }

  void _emitLoaded(List<Player> players) {
    final selectedCount = players.where((p) => p.isSelected).length;
    emit(PlayersLoaded(players: players, selectedCount: selectedCount));
  }
}
