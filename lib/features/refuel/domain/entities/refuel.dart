import '../../../../core/enums/fuel_type.dart';

class Refuel {
  const Refuel({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.amountPaid,
    required this.liters,
    required this.fuelType,
    required this.odometer,
    required this.fullTank,
    this.notes,
  });

  final String id;
  final String vehicleId;
  final DateTime date;

  /// Amount paid, in R$.
  final double amountPaid;
  final double liters;
  final FuelType fuelType;

  /// Odometer reading at this stop, in kilometers.
  final int odometer;

  /// Whether this was a complete fill (basis for accurate consumption).
  final bool fullTank;
  final String? notes;

  Refuel copyWith({
    String? id,
    String? vehicleId,
    DateTime? date,
    double? amountPaid,
    double? liters,
    FuelType? fuelType,
    int? odometer,
    bool? fullTank,
    String? notes,
  }) {
    return Refuel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      amountPaid: amountPaid ?? this.amountPaid,
      liters: liters ?? this.liters,
      fuelType: fuelType ?? this.fuelType,
      odometer: odometer ?? this.odometer,
      fullTank: fullTank ?? this.fullTank,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Refuel &&
          other.id == id &&
          other.vehicleId == vehicleId &&
          other.date == date &&
          other.amountPaid == amountPaid &&
          other.liters == liters &&
          other.fuelType == fuelType &&
          other.odometer == odometer &&
          other.fullTank == fullTank &&
          other.notes == notes;

  @override
  int get hashCode => Object.hash(id, vehicleId, date, amountPaid, liters,
      fuelType, odometer, fullTank, notes);
}
