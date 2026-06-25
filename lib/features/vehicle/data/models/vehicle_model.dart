import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/database/hive_config.dart';
import '../../../../core/enums/fuel_type.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_type.dart';

class VehicleModel {
  const VehicleModel({
    required this.id,
    required this.name,
    required this.typeIndex,
    required this.fuelTypeIndex,
    required this.currentMileage,
  });

  factory VehicleModel.fromEntity(Vehicle vehicle) => VehicleModel(
        id: vehicle.id,
        name: vehicle.name,
        typeIndex: vehicle.type.index,
        fuelTypeIndex: vehicle.fuelType.index,
        currentMileage: vehicle.currentMileage,
      );

  final String id;
  final String name;
  final int typeIndex;
  final int fuelTypeIndex;
  final int currentMileage;

  Vehicle toEntity() => Vehicle(
        id: id,
        name: name,
        type: VehicleType.values[typeIndex],
        fuelType: FuelType.values[fuelTypeIndex],
        currentMileage: currentMileage,
      );
}

class VehicleModelAdapter extends TypeAdapter<VehicleModel> {
  @override
  final int typeId = HiveTypeIds.vehicle;

  @override
  VehicleModel read(BinaryReader reader) {
    return VehicleModel(
      id: reader.readString(),
      name: reader.readString(),
      typeIndex: reader.readInt(),
      fuelTypeIndex: reader.readInt(),
      currentMileage: reader.readInt(),
    );
  }

  // Fields are written in a fixed order; if you add fields, append them.
  @override
  void write(BinaryWriter writer, VehicleModel obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeInt(obj.typeIndex)
      ..writeInt(obj.fuelTypeIndex)
      ..writeInt(obj.currentMileage);
  }
}
