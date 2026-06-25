import '../entities/refuel.dart';
import '../repositories/refuel_repository.dart';

class GetRefuelsUseCase {
  const GetRefuelsUseCase(this._repository);

  final RefuelRepository _repository;

  Future<List<Refuel>> call() => _repository.getAll();
}
