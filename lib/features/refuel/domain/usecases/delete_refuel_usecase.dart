import '../repositories/refuel_repository.dart';

class DeleteRefuelUseCase {
  const DeleteRefuelUseCase(this._repository);

  final RefuelRepository _repository;

  Future<void> call(String id) => _repository.delete(id);
}
