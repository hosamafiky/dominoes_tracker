import '../../../../core/usecases/usecase.dart';
import '../repositories/session_repository.dart';

class GetTotalSessions extends UseCase<int, NoParams> {
  final SessionRepository repository;

  GetTotalSessions(this.repository);

  @override
  Future<int> call(NoParams params) async {
    return await repository.getTotalSessionsCount();
  }
}
