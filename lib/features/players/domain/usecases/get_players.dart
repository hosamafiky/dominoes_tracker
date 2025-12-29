import '../../../../core/usecases/usecase.dart';
import '../entities/player.dart';
import '../repositories/player_repository.dart';

class GetPlayers extends UseCase<List<Player>, NoParams> {
  final PlayerRepository repository;

  GetPlayers(this.repository);

  @override
  Future<List<Player>> call(NoParams params) async {
    return await repository.getPlayers();
  }
}
