import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/database/hive_config.dart';
import '../../../../core/enums/fuel_type.dart';
import '../../../vehicle/domain/entities/vehicle.dart';
import '../../../vehicle/presentation/providers/vehicle_providers.dart';
import '../../data/datasources/refuel_local_data_source.dart';
import '../../data/models/refuel_model.dart';
import '../../data/repositories/refuel_repository_impl.dart';
import '../../domain/entities/refuel.dart';
import '../../domain/refuel_calculations.dart';
import '../../domain/repositories/refuel_repository.dart';
import '../../domain/usecases/delete_refuel_usecase.dart';
import '../../domain/usecases/get_refuels_usecase.dart';
import '../../domain/usecases/register_refuel_usecase.dart';
import '../../domain/usecases/update_refuel_usecase.dart';

// Opened during initHive() before the app starts.
final _refuelBoxProvider = Provider<Box<RefuelModel>>((ref) {
  return Hive.box<RefuelModel>(HiveBoxes.refuels);
});

final refuelLocalDataSourceProvider = Provider<RefuelLocalDataSource>((ref) {
  return RefuelLocalDataSource(ref.watch(_refuelBoxProvider));
});

final refuelRepositoryProvider = Provider<RefuelRepository>((ref) {
  return RefuelRepositoryImpl(ref.watch(refuelLocalDataSourceProvider));
});

class RefuelListNotifier extends AsyncNotifier<List<Refuel>> {
  late final RefuelRepository _repository = ref.read(refuelRepositoryProvider);

  @override
  Future<List<Refuel>> build() {
    return GetRefuelsUseCase(_repository)();
  }

  Future<void> register({
    required String vehicleId,
    required DateTime date,
    required double amountPaid,
    required double liters,
    required FuelType fuelType,
    required int odometer,
    required bool fullTank,
    String? notes,
  }) async {
    await RegisterRefuelUseCase(_repository)(
      vehicleId: vehicleId,
      date: date,
      amountPaid: amountPaid,
      liters: liters,
      fuelType: fuelType,
      odometer: odometer,
      fullTank: fullTank,
      notes: notes,
    );
    await _bumpVehicleOdometer(vehicleId, odometer);
    await _reload();
  }

  Future<void> edit(Refuel refuel) async {
    await UpdateRefuelUseCase(_repository)(refuel);
    await _bumpVehicleOdometer(refuel.vehicleId, refuel.odometer);
    await _reload();
  }

  Future<void> remove(String id) async {
    await DeleteRefuelUseCase(_repository)(id);
    await _reload();
  }

  Future<void> removeForVehicle(String vehicleId) async {
    await _repository.deleteForVehicle(vehicleId);
    await _reload();
  }

  /// Pushes the owning vehicle's odometer forward when this stop is higher
  /// (refuel → vehicle, presentation-layer coordination).
  Future<void> _bumpVehicleOdometer(String vehicleId, int odometer) async {
    final vehicle =
        ref.read(vehicleListProvider).value?.firstWhereOrNullId(vehicleId);
    if (vehicle != null && odometer > vehicle.currentMileage) {
      await ref
          .read(vehicleListProvider.notifier)
          .edit(vehicle.copyWith(currentMileage: odometer));
    }
  }

  Future<void> _reload() async {
    state = await AsyncValue.guard(() => GetRefuelsUseCase(_repository)());
  }
}

final refuelListProvider =
    AsyncNotifierProvider<RefuelListNotifier, List<Refuel>>(
  RefuelListNotifier.new,
);

/// A single vehicle's refuelings (unsorted), derived from the full list.
final refuelsForVehicleProvider =
    Provider.family<List<Refuel>, String>((ref, vehicleId) {
  final all = ref.watch(refuelListProvider).value ?? const <Refuel>[];
  return all.where((r) => r.vehicleId == vehicleId).toList(growable: false);
});

/// Average consumption (km/l) for a vehicle, or null when not computable.
final vehicleAverageConsumptionProvider =
    Provider.family<double?, String>((ref, vehicleId) {
  return RefuelCalculations.averageConsumption(
    ref.watch(refuelsForVehicleProvider(vehicleId)),
  );
});

class DashboardStats {
  const DashboardStats({
    required this.vehicle,
    required this.entries,
    required this.averageConsumption,
    required this.monthlySpend,
    required this.lastRefuel,
  });

  final Vehicle? vehicle;
  final List<RefuelEntry> entries; // newest first
  final double? averageConsumption;
  final double monthlySpend;
  final Refuel? lastRefuel;

  ConsumptionTrend get averageTrend =>
      entries.isEmpty ? ConsumptionTrend.flat : entries.first.trend;
}

final dashboardStatsProvider =
    Provider.family<DashboardStats, String>((ref, vehicleId) {
  final refuels = ref.watch(refuelsForVehicleProvider(vehicleId));
  final vehicle =
      ref.watch(vehicleListProvider).value?.firstWhereOrNullId(vehicleId);
  return DashboardStats(
    vehicle: vehicle,
    entries: RefuelCalculations.withConsumption(refuels),
    averageConsumption: RefuelCalculations.averageConsumption(refuels),
    monthlySpend: RefuelCalculations.monthlySpend(refuels, DateTime.now()),
    lastRefuel: RefuelCalculations.lastRefuel(refuels),
  );
});

extension _FindVehicle on List<Vehicle> {
  Vehicle? firstWhereOrNullId(String id) {
    for (final v in this) {
      if (v.id == id) return v;
    }
    return null;
  }
}
