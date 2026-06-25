enum FuelType {
  gasolina,
  etanol,
  diesel,
  gnv;

  String get label => switch (this) {
        FuelType.gasolina => 'Gasolina',
        FuelType.etanol => 'Etanol',
        FuelType.diesel => 'Diesel',
        FuelType.gnv => 'GNV',
      };
}
