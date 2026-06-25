import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class GetVehiclesUseCase {
  const GetVehiclesUseCase(this._repository);

  final VehicleRepository _repository;

  Future<List<Vehicle>> call() => _repository.getAll();
}
