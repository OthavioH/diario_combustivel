import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/vehicle_local_data_source.dart';
import '../models/vehicle_model.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  const VehicleRepositoryImpl(this._dataSource);

  final VehicleLocalDataSource _dataSource;

  @override
  Future<List<Vehicle>> getAll() async => _dataSource
      .getAll()
      .map((model) => model.toEntity())
      .toList(growable: false);

  @override
  Future<void> add(Vehicle vehicle) =>
      _dataSource.put(VehicleModel.fromEntity(vehicle));

  @override
  Future<void> update(Vehicle vehicle) =>
      _dataSource.put(VehicleModel.fromEntity(vehicle));

  @override
  Future<void> delete(String id) => _dataSource.delete(id);
}
