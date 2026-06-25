import '../entities/refuel.dart';
import '../repositories/refuel_repository.dart';

class UpdateRefuelUseCase {
  const UpdateRefuelUseCase(this._repository);

  final RefuelRepository _repository;

  Future<void> call(Refuel refuel) => _repository.update(refuel);
}
