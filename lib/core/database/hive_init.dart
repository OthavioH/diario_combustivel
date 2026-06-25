import 'package:hive_flutter/hive_flutter.dart';

import '../../features/refuel/data/models/refuel_model.dart';
import '../../features/vehicle/data/models/vehicle_model.dart';
import 'hive_config.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(HiveTypeIds.vehicle)) {
    Hive.registerAdapter(VehicleModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveTypeIds.refuel)) {
    Hive.registerAdapter(RefuelModelAdapter());
  }

  await Hive.openBox<VehicleModel>(HiveBoxes.vehicles);
  await Hive.openBox<RefuelModel>(HiveBoxes.refuels);
}
