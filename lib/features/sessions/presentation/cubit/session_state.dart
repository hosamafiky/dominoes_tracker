part of 'session_cubit.dart';

class SessionState extends Equatable {
  const SessionState({
    this.countStatus = UseCaseStatus.initial,
    this.sessionStatus = UseCaseStatus.initial,
    this.addRoundStatus = UseCaseStatus.initial,
    this.watchSessionStatus = UseCaseStatus.initial,
    this.completeSessionStatus = UseCaseStatus.initial,
    this.roundsStatus = UseCaseStatus.initial,
    this.countError,
    this.sessionError,
    this.addRoundError,
    this.watchSessionError,
    this.completeSessionError,
    this.roundsError,
    this.count = 0,
    this.session,
    this.rounds = const [],
  });

  final UseCaseStatus countStatus;
  final UseCaseStatus sessionStatus;
  final UseCaseStatus addRoundStatus;
  final UseCaseStatus watchSessionStatus;
  final UseCaseStatus completeSessionStatus;
  final UseCaseStatus roundsStatus;

  final String? countError;
  final String? sessionError;
  final String? addRoundError;
  final String? watchSessionError;
  final String? completeSessionError;
  final String? roundsError;

  final int count;
  final Session? session;
  final List<Round> rounds;

  SessionState copyWith({
    UseCaseStatus? countStatus,
    UseCaseStatus? sessionStatus,
    UseCaseStatus? addRoundStatus,
    UseCaseStatus? watchSessionStatus,
    UseCaseStatus? completeSessionStatus,
    String? countError,
    String? sessionError,
    String? addRoundError,
    String? watchSessionError,
    String? completeSessionError,
    int? count,
    Session? session,
    UseCaseStatus? roundsStatus,
    String? roundsError,
    List<Round>? rounds,
  }) {
    return SessionState(
      countStatus: countStatus ?? this.countStatus,
      sessionStatus: sessionStatus ?? this.sessionStatus,
      addRoundStatus: addRoundStatus ?? this.addRoundStatus,
      watchSessionStatus: watchSessionStatus ?? this.watchSessionStatus,
      completeSessionStatus: completeSessionStatus ?? this.completeSessionStatus,
      countError: countError ?? this.countError,
      sessionError: sessionError ?? this.sessionError,
      addRoundError: addRoundError ?? this.addRoundError,
      watchSessionError: watchSessionError ?? this.watchSessionError,
      completeSessionError: completeSessionError ?? this.completeSessionError,
      count: count ?? this.count,
      session: session ?? this.session,
      roundsStatus: roundsStatus ?? this.roundsStatus,
      roundsError: roundsError ?? this.roundsError,
      rounds: rounds ?? this.rounds,
    );
  }

  @override
  List<Object?> get props => [
    countStatus,
    sessionStatus,
    addRoundStatus,
    watchSessionStatus,
    completeSessionStatus,
    countError,
    sessionError,
    addRoundError,
    watchSessionError,
    completeSessionError,
    count,
    session,
    roundsStatus,
    roundsError,
    rounds,
  ];
}
