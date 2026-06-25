import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/database/hive_config.dart';
import '../../data/datasources/vehicle_local_data_source.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/repositories/vehicle_repository_impl.dart';
import '../../../../core/enums/fuel_type.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_type.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../../domain/usecases/delete_vehicle_usecase.dart';
import '../../domain/usecases/get_vehicles_usecase.dart';
import '../../domain/usecases/register_vehicle_usecase.dart';
import '../../domain/usecases/update_vehicle_usecase.dart';

// Opened during initHive() before the app starts.
final _vehicleBoxProvider = Provider<Box<VehicleModel>>((ref) {
  return Hive.box<VehicleModel>(HiveBoxes.vehicles);
});

final vehicleLocalDataSourceProvider = Provider<VehicleLocalDataSource>((ref) {
  return VehicleLocalDataSource(ref.watch(_vehicleBoxProvider));
});

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepositoryImpl(ref.watch(vehicleLocalDataSourceProvider));
});

class VehicleListNotifier extends AsyncNotifier<List<Vehicle>> {
  late final VehicleRepository _repository =
      ref.read(vehicleRepositoryProvider);

  @override
  Future<List<Vehicle>> build() {
    return GetVehiclesUseCase(_repository)();
  }

  Future<void> register({
    required String name,
    required VehicleType type,
    required FuelType fuelType,
    required int currentMileage,
  }) async {
    await RegisterVehicleUseCase(_repository)(
      name: name,
      type: type,
      fuelType: fuelType,
      currentMileage: currentMileage,
    );
    await _reload();
  }

  Future<void> edit(Vehicle vehicle) async {
    await UpdateVehicleUseCase(_repository)(vehicle);
    await _reload();
  }

  Future<void> remove(String id) async {
    await DeleteVehicleUseCase(_repository)(id);
    await _reload();
  }

  Future<void> _reload() async {
    state = await AsyncValue.guard(() => GetVehiclesUseCase(_repository)());
  }
}

final vehicleListProvider =
    AsyncNotifierProvider<VehicleListNotifier, List<Vehicle>>(
  VehicleListNotifier.new,
);
