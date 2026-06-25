import 'entities/refuel.dart';

enum ConsumptionTrend { up, down, flat }

/// A refueling paired with its computed consumption and trend.
class RefuelEntry {
  const RefuelEntry({
    required this.refuel,
    required this.kmPerLiter,
    required this.trend,
  });

  final Refuel refuel;

  /// km/l for the interval ending at this stop, or null for the first stop
  /// (no previous odometer to measure against).
  final double? kmPerLiter;
  final ConsumptionTrend trend;
}

/// Pure consumption math over a single vehicle's refuelings.
///
/// Per-stop km/l = distance since the previous stop / liters filled at this stop.
/// Average consumption favors full-tank intervals; partial fills are still shown.
abstract final class RefuelCalculations {
  /// Refuelings with consumption + trend, **newest first** (display order).
  static List<RefuelEntry> withConsumption(List<Refuel> refuels) {
    final ascending = [...refuels]
      ..sort((a, b) => a.odometer.compareTo(b.odometer));

    final entries = <RefuelEntry>[];
    double? previousConsumption;
    for (var i = 0; i < ascending.length; i++) {
      final current = ascending[i];
      double? kmPerLiter;
      if (i > 0) {
        final distance = current.odometer - ascending[i - 1].odometer;
        if (distance > 0 && current.liters > 0) {
          kmPerLiter = distance / current.liters;
        }
      }

      var trend = ConsumptionTrend.flat;
      if (kmPerLiter != null && previousConsumption != null) {
        if (kmPerLiter > previousConsumption) {
          trend = ConsumptionTrend.up;
        } else if (kmPerLiter < previousConsumption) {
          trend = ConsumptionTrend.down;
        }
      }
      if (kmPerLiter != null) previousConsumption = kmPerLiter;

      entries.add(RefuelEntry(
        refuel: current,
        kmPerLiter: kmPerLiter,
        trend: trend,
      ));
    }

    return entries.reversed.toList(growable: false);
  }

  /// Average km/l: total distance over total liters across full-tank intervals
  /// (falls back to all intervals if none are full-tank). Null if not computable.
  static double? averageConsumption(List<Refuel> refuels) {
    final ascending = [...refuels]
      ..sort((a, b) => a.odometer.compareTo(b.odometer));
    if (ascending.length < 2) return null;

    double fullDistance = 0, fullLiters = 0;
    double anyDistance = 0, anyLiters = 0;
    for (var i = 1; i < ascending.length; i++) {
      final distance = ascending[i].odometer - ascending[i - 1].odometer;
      final liters = ascending[i].liters;
      if (distance <= 0 || liters <= 0) continue;
      anyDistance += distance;
      anyLiters += liters;
      if (ascending[i].fullTank) {
        fullDistance += distance;
        fullLiters += liters;
      }
    }

    if (fullLiters > 0) return fullDistance / fullLiters;
    if (anyLiters > 0) return anyDistance / anyLiters;
    return null;
  }

  /// Total amount paid (R$) for refuelings in the same calendar month as [month].
  static double monthlySpend(List<Refuel> refuels, DateTime month) {
    return refuels
        .where((r) => r.date.year == month.year && r.date.month == month.month)
        .fold(0, (sum, r) => sum + r.amountPaid);
  }

  /// Most recent refueling by date, or null when there are none.
  static Refuel? lastRefuel(List<Refuel> refuels) {
    if (refuels.isEmpty) return null;
    return refuels.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
  }
}
