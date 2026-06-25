import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../refuel/domain/entities/refuel.dart';
import '../../../refuel/presentation/providers/refuel_providers.dart';
import '../../../vehicle/domain/entities/vehicle.dart';
import '../../../vehicle/presentation/providers/vehicle_providers.dart';
import '../report_calculations.dart';

/// The Reports view-model, recomputed whenever vehicles or refuelings change.
final reportDataProvider = Provider<ReportData>((ref) {
  final vehicles = ref.watch(vehicleListProvider).value ?? const <Vehicle>[];
  final refuels = ref.watch(refuelListProvider).value ?? const <Refuel>[];
  return ReportCalculations.build(
    vehicles: vehicles,
    refuels: refuels,
    now: DateTime.now(),
  );
});
