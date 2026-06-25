import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class UpdateVehicleUseCase {
  const UpdateVehicleUseCase(this._repository);

  final VehicleRepository _repository;

  Future<void> call(Vehicle vehicle) =>
      _repository.update(vehicle.copyWith(name: vehicle.name.trim()));
}
