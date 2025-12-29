import '../../../../core/usecases/usecase.dart';
import '../repositories/player_repository.dart';

class TogglePlayerSelection extends UseCase<void, String> {
  final PlayerRepository repository;

  TogglePlayerSelection(this.repository);

  @override
  Future<void> call(String playerId) async {
    return await repository.togglePlayerSelection(playerId);
  }
}
