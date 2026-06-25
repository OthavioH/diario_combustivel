import 'package:hive_flutter/hive_flutter.dart';

import '../models/vehicle_model.dart';

class VehicleLocalDataSource {
  const VehicleLocalDataSource(this._box);

  final Box<VehicleModel> _box;

  List<VehicleModel> getAll() => _box.values.toList(growable: false);

  Future<void> put(VehicleModel model) => _box.put(model.id, model);

  Future<void> delete(String id) => _box.delete(id);
}
