import '../repositories/vehicle_repository.dart';

class DeleteVehicleUseCase {
  const DeleteVehicleUseCase(this._repository);

  final VehicleRepository _repository;

  // The refuel cascade is handled at the presentation layer (the vehicle list
  // delete action also calls RefuelListNotifier.removeForVehicle).
  Future<void> call(String id) => _repository.delete(id);
}
