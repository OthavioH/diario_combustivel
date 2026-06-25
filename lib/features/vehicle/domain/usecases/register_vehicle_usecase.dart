import 'package:uuid/uuid.dart';

import '../../../../core/enums/fuel_type.dart';
import '../entities/vehicle.dart';
import '../entities/vehicle_type.dart';
import '../repositories/vehicle_repository.dart';

class RegisterVehicleUseCase {
  const RegisterVehicleUseCase(this._repository, {Uuid uuid = const Uuid()})
      : _uuid = uuid;

  final VehicleRepository _repository;
  final Uuid _uuid;

  Future<Vehicle> call({
    required String name,
    required VehicleType type,
    required FuelType fuelType,
    required int currentMileage,
  }) async {
    final vehicle = Vehicle(
      id: _uuid.v4(),
      name: name.trim(),
      type: type,
      fuelType: fuelType,
      currentMileage: currentMileage,
    );
    await _repository.add(vehicle);
    return vehicle;
  }
}
