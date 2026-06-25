import 'package:flutter/material.dart';

/// Persisted by enum index (see `VehicleModelAdapter`): never reorder existing
/// values, only append.
enum VehicleType {
  carro,
  moto;

  String get label => switch (this) {
        VehicleType.carro => 'Carro',
        VehicleType.moto => 'Moto',
      };

  IconData get icon => switch (this) {
        VehicleType.carro => Icons.directions_car,
        VehicleType.moto => Icons.two_wheeler,
      };
}
