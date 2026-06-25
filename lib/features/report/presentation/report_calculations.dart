import '../../refuel/domain/entities/refuel.dart';
import '../../refuel/domain/refuel_calculations.dart';
import '../../vehicle/domain/entities/vehicle.dart';

/// Total spend for one calendar month.
class MonthlySpend {
  const MonthlySpend({required this.month, required this.total});
  final DateTime month;
  final double total;
}

/// A vehicle paired with its average efficiency (null when not computable).
class VehicleEfficiency {
  const VehicleEfficiency({required this.vehicle, required this.kmPerLiter});
  final Vehicle vehicle;
  final double? kmPerLiter;
}

/// Everything the Reports screen renders, aggregated across all vehicles.
class ReportData {
  const ReportData({
    required this.avgCostPerKm,
    required this.costPerKmVariation,
    required this.yearlySpend,
    required this.yearlyVariation,
    required this.monthlySeries,
    required this.sixMonthTotal,
    required this.efficiency,
    required this.hasData,
  });

  final double? avgCostPerKm;
  final double? costPerKmVariation;
  final double yearlySpend;
  final double? yearlyVariation;
  final List<MonthlySpend> monthlySeries; // oldest -> newest
  final double sixMonthTotal;
  final List<VehicleEfficiency> efficiency; // best -> worst
  final bool hasData;
}

/// Pure, read-only aggregation of vehicle + refuel data for the Reports screen.
abstract final class ReportCalculations {
  static ReportData build({
    required List<Vehicle> vehicles,
    required List<Refuel> refuels,
    required DateTime now,
  }) {
    final series = monthlySpending(refuels, now);
    final thisMonthCost = costPerKm(refuels, year: now.year, month: now.month);
    final prevMonthAnchor = DateTime(now.year, now.month - 1);
    final lastMonthCost =
        costPerKm(refuels, year: prevMonthAnchor.year, month: prevMonthAnchor.month);

    final thisYear = yearlySpend(refuels, now.year);
    final lastYear = yearlySpend(refuels, now.year - 1);

    return ReportData(
      avgCostPerKm: thisMonthCost,
      costPerKmVariation: variation(thisMonthCost, lastMonthCost),
      yearlySpend: thisYear,
      yearlyVariation: variation(thisYear, lastYear),
      monthlySeries: series,
      sixMonthTotal: series.fold(0, (sum, m) => sum + m.total),
      efficiency: efficiencyByVehicle(vehicles, refuels),
      hasData: refuels.isNotEmpty,
    );
  }

  /// Σ amountPaid per calendar month for the last [months] months (gaps -> 0),
  /// oldest first.
  static List<MonthlySpend> monthlySpending(
    List<Refuel> refuels,
    DateTime now, {
    int months = 6,
  }) {
    return [
      for (var i = months - 1; i >= 0; i--)
        () {
          final anchor = DateTime(now.year, now.month - i);
          final total = refuels
              .where((r) =>
                  r.date.year == anchor.year && r.date.month == anchor.month)
              .fold<double>(0, (sum, r) => sum + r.amountPaid);
          return MonthlySpend(month: anchor, total: total);
        }(),
    ];
  }

  static double yearlySpend(List<Refuel> refuels, int year) => refuels
      .where((r) => r.date.year == year)
      .fold(0, (sum, r) => sum + r.amountPaid);

  /// Cost per km = Σ amountPaid ÷ Σ distance over measurable intervals (per
  /// vehicle, consecutive odometer stops). Optionally filtered to the calendar
  /// month/year of the interval's closing stop. Null when no measurable distance.
  static double? costPerKm(List<Refuel> refuels, {int? year, int? month}) {
    final byVehicle = <String, List<Refuel>>{};
    for (final r in refuels) {
      (byVehicle[r.vehicleId] ??= []).add(r);
    }

    double cost = 0, distance = 0;
    for (final list in byVehicle.values) {
      list.sort((a, b) => a.odometer.compareTo(b.odometer));
      for (var i = 1; i < list.length; i++) {
        final current = list[i];
        if (year != null && current.date.year != year) continue;
        if (month != null && current.date.month != month) continue;
        final d = current.odometer - list[i - 1].odometer;
        if (d <= 0) continue;
        distance += d;
        cost += current.amountPaid;
      }
    }

    return distance > 0 ? cost / distance : null;
  }

  static List<VehicleEfficiency> efficiencyByVehicle(
    List<Vehicle> vehicles,
    List<Refuel> refuels,
  ) {
    final result = [
      for (final vehicle in vehicles)
        VehicleEfficiency(
          vehicle: vehicle,
          kmPerLiter: RefuelCalculations.averageConsumption(
            refuels.where((r) => r.vehicleId == vehicle.id).toList(),
          ),
        ),
    ]..sort((a, b) {
        if (a.kmPerLiter == null) return 1;
        if (b.kmPerLiter == null) return -1;
        return b.kmPerLiter!.compareTo(a.kmPerLiter!);
      });
    return result;
  }

  /// (current − previous) / previous, or null when [previous] is null/zero.
  static double? variation(double? current, double? previous) {
    if (current == null || previous == null || previous == 0) return null;
    return (current - previous) / previous;
  }
}
