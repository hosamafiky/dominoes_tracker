import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/player_repository.dart';

class TogglePlayerSelection {
  final PlayerRepository repository;

  TogglePlayerSelection(this.repository);

  Future<Either<Failure, void>> call(String params) async {
    return await repository.togglePlayerSelection(params);
  }
}
