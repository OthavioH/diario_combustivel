import '../../domain/entities/refuel.dart';
import '../../domain/repositories/refuel_repository.dart';
import '../datasources/refuel_local_data_source.dart';
import '../models/refuel_model.dart';

class RefuelRepositoryImpl implements RefuelRepository {
  const RefuelRepositoryImpl(this._dataSource);

  final RefuelLocalDataSource _dataSource;

  @override
  Future<List<Refuel>> getAll() async => _dataSource
      .getAll()
      .map((model) => model.toEntity())
      .toList(growable: false);

  @override
  Future<void> add(Refuel refuel) =>
      _dataSource.put(RefuelModel.fromEntity(refuel));

  @override
  Future<void> update(Refuel refuel) =>
      _dataSource.put(RefuelModel.fromEntity(refuel));

  @override
  Future<void> delete(String id) => _dataSource.delete(id);

  @override
  Future<void> deleteForVehicle(String vehicleId) =>
      _dataSource.deleteForVehicle(vehicleId);
}
