import '../entities/refuel.dart';

abstract interface class RefuelRepository {
  Future<List<Refuel>> getAll();

  Future<void> add(Refuel refuel);

  Future<void> update(Refuel refuel);

  Future<void> delete(String id);

  Future<void> deleteForVehicle(String vehicleId);
}
