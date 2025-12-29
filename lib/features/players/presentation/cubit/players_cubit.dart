import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
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
    try {
      final players = await getPlayers(NoParams());
      _emitLoaded(players);
    } catch (e) {
      emit(PlayersError(e.toString()));
    }
  }

  Future<void> toggleSelection(String playerId) async {
    if (state is PlayersLoaded) {
      final currentState = state as PlayersLoaded;
      try {
        await togglePlayerSelection(playerId);
        final updatedPlayers = currentState.players.map((p) {
          if (p.id == playerId) {
            return p.copyWith(isSelected: !p.isSelected);
          }
          return p;
        }).toList();
        _emitLoaded(updatedPlayers);
      } catch (e) {
        emit(PlayersError(e.toString()));
      }
    }
  }

  void _emitLoaded(List<Player> players) {
    final selectedCount = players.where((p) => p.isSelected).length;
    emit(PlayersLoaded(players: players, selectedCount: selectedCount));
  }
}
