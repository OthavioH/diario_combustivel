import '../../../../core/enums/fuel_type.dart';
import 'vehicle_type.dart';

class Vehicle {
  const Vehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.fuelType,
    required this.currentMileage,
  });

  final String id;
  final String name;
  final VehicleType type;
  final FuelType fuelType;

  /// Odometer reading in kilometers; non-negative.
  final int currentMileage;

  Vehicle copyWith({
    String? id,
    String? name,
    VehicleType? type,
    FuelType? fuelType,
    int? currentMileage,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      fuelType: fuelType ?? this.fuelType,
      currentMileage: currentMileage ?? this.currentMileage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vehicle &&
          other.id == id &&
          other.name == name &&
          other.type == type &&
          other.fuelType == fuelType &&
          other.currentMileage == currentMileage;

  @override
  int get hashCode => Object.hash(id, name, type, fuelType, currentMileage);

  @override
  String toString() =>
      'Vehicle(id: $id, name: $name, type: $type, fuelType: $fuelType, '
      'currentMileage: $currentMileage)';
}
