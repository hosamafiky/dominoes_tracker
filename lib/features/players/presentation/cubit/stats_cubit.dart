import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/player_stats.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  StatsCubit() : super(StatsInitial());

  Future<void> loadPlayerStats(String playerId) async {
    emit(StatsLoading());
    try {
      // Mocking stats for now, in a real app this would call a repository
      // that aggregates session data from Firestore.
      await Future.delayed(const Duration(seconds: 1));
      final stats = PlayerStats(totalGames: 60, wins: 42, losses: 18, winRate: 0.68, currentStreak: 5, bestPartner: 'Sarah Miller', nemesis: 'Mike Ross');
      emit(StatsLoaded(stats));
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }
}
