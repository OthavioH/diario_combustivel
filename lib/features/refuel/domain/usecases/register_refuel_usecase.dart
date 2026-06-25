import 'package:uuid/uuid.dart';

import '../../../../core/enums/fuel_type.dart';
import '../entities/refuel.dart';
import '../repositories/refuel_repository.dart';

class RegisterRefuelUseCase {
  const RegisterRefuelUseCase(this._repository, {Uuid uuid = const Uuid()})
      : _uuid = uuid;

  final RefuelRepository _repository;
  final Uuid _uuid;

  Future<Refuel> call({
    required String vehicleId,
    required DateTime date,
    required double amountPaid,
    required double liters,
    required FuelType fuelType,
    required int odometer,
    required bool fullTank,
    String? notes,
  }) async {
    final refuel = Refuel(
      id: _uuid.v4(),
      vehicleId: vehicleId,
      date: date,
      amountPaid: amountPaid,
      liters: liters,
      fuelType: fuelType,
      odometer: odometer,
      fullTank: fullTank,
      notes: notes,
    );
    await _repository.add(refuel);
    return refuel;
  }
}
