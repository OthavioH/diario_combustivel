import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/database/hive_config.dart';
import '../../../../core/enums/fuel_type.dart';
import '../../domain/entities/refuel.dart';

class RefuelModel {
  const RefuelModel({
    required this.id,
    required this.vehicleId,
    required this.dateMillis,
    required this.amountPaid,
    required this.liters,
    required this.fuelTypeIndex,
    required this.odometer,
    required this.fullTank,
    required this.notes,
  });

  factory RefuelModel.fromEntity(Refuel refuel) => RefuelModel(
        id: refuel.id,
        vehicleId: refuel.vehicleId,
        dateMillis: refuel.date.millisecondsSinceEpoch,
        amountPaid: refuel.amountPaid,
        liters: refuel.liters,
        fuelTypeIndex: refuel.fuelType.index,
        odometer: refuel.odometer,
        fullTank: refuel.fullTank,
        notes: refuel.notes ?? '',
      );

  final String id;
  final String vehicleId;
  final int dateMillis;
  final double amountPaid;
  final double liters;
  final int fuelTypeIndex;
  final int odometer;
  final bool fullTank;
  final String notes;

  Refuel toEntity() => Refuel(
        id: id,
        vehicleId: vehicleId,
        date: DateTime.fromMillisecondsSinceEpoch(dateMillis),
        amountPaid: amountPaid,
        liters: liters,
        fuelType: FuelType.values[fuelTypeIndex],
        odometer: odometer,
        fullTank: fullTank,
        notes: notes.isEmpty ? null : notes,
      );
}

class RefuelModelAdapter extends TypeAdapter<RefuelModel> {
  @override
  final int typeId = HiveTypeIds.refuel;

  @override
  RefuelModel read(BinaryReader reader) {
    return RefuelModel(
      id: reader.readString(),
      vehicleId: reader.readString(),
      dateMillis: reader.readInt(),
      amountPaid: reader.readDouble(),
      liters: reader.readDouble(),
      fuelTypeIndex: reader.readInt(),
      odometer: reader.readInt(),
      fullTank: reader.readBool(),
      notes: reader.readString(),
    );
  }

  // Fields are written in a fixed order; if you add fields, append them.
  @override
  void write(BinaryWriter writer, RefuelModel obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.vehicleId)
      ..writeInt(obj.dateMillis)
      ..writeDouble(obj.amountPaid)
      ..writeDouble(obj.liters)
      ..writeInt(obj.fuelTypeIndex)
      ..writeInt(obj.odometer)
      ..writeBool(obj.fullTank)
      ..writeString(obj.notes);
  }
}
