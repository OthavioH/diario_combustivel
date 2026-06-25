import '../entities/vehicle.dart';

abstract interface class VehicleRepository {
  Future<List<Vehicle>> getAll();

  Future<void> add(Vehicle vehicle);

  Future<void> update(Vehicle vehicle);

  Future<void> delete(String id);
}
