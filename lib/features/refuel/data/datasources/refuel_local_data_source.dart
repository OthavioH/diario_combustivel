import 'package:hive_flutter/hive_flutter.dart';

import '../models/refuel_model.dart';

class RefuelLocalDataSource {
  const RefuelLocalDataSource(this._box);

  final Box<RefuelModel> _box;

  List<RefuelModel> getAll() => _box.values.toList(growable: false);

  Future<void> put(RefuelModel model) => _box.put(model.id, model);

  Future<void> delete(String id) => _box.delete(id);

  Future<void> deleteForVehicle(String vehicleId) async {
    final ids = _box.values
        .where((m) => m.vehicleId == vehicleId)
        .map((m) => m.id)
        .toList(growable: false);
    await _box.deleteAll(ids);
  }
}
