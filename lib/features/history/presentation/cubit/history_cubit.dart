import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../sessions/domain/entities/session.dart';
import '../../../sessions/domain/repositories/session_repository.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final SessionRepository repository;

  HistoryCubit({required this.repository}) : super(HistoryInitial());

  Future<void> fetchHistory() async {
    emit(HistoryLoading());
    final result = await repository.getSessionHistory();
    result.fold((failure) => emit(HistoryError(failure.message)), (history) => emit(HistoryLoaded(history)));
  }
}
