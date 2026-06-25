import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../refuel/domain/refuel_calculations.dart';
import '../../../refuel/presentation/providers/refuel_providers.dart';
import '../../../refuel/presentation/widgets/dashboard_metric_card.dart';
import '../../../refuel/presentation/widgets/refuel_list_tile.dart';

/// Per-vehicle dashboard: consumption, monthly spend, last refuel, odometer and
/// recent activity. Composes refuel data (allowed at the presentation layer).
class VehicleDashboardScreen extends ConsumerWidget {
  const VehicleDashboardScreen({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final stats = ref.watch(dashboardStatsProvider(vehicleId));
    final vehicle = stats.vehicle;

    if (vehicle == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(vehicle.name)),
      body: ListView(
        padding: EdgeInsets.all(spacing.containerPadding),
        children: [
          _HeaderBand(name: vehicle.name, typeLabel: vehicle.type.label),
          SizedBox(height: spacing.stackLg),
          _MetricsGrid(stats: stats, odometer: vehicle.currentMileage),
          SizedBox(height: spacing.stackLg),
          _RecentActivity(
            entries: stats.entries,
            onSeeAll: () => context.goHistory(),
            onTapEntry: (refuelId) =>
                context.pushRefuelEdit(vehicleId, refuelId),
            onAddFirst: () => context.pushNewRefuel(vehicleId),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNewRefuel(vehicleId),
        icon: const Icon(Icons.local_gas_station),
        label: const Text('Abastecer'),
      ),
    );
  }
}

class _HeaderBand extends StatelessWidget {
  const _HeaderBand({required this.name, required this.typeLabel});

  final String name;
  final String typeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.stackLg),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: context.radii.xlRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VEÍCULO ATIVO',
            style: theme.textTheme.labelMedium
                ?.copyWith(color: colors.onPrimaryContainer),
          ),
          SizedBox(height: spacing.stackSm),
          Text(
            name,
            style: theme.textTheme.headlineSmall
                ?.copyWith(color: colors.onPrimaryContainer),
          ),
          Text(
            typeLabel,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: colors.onPrimaryContainer),
          ),
        ],
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.stats, required this.odometer});

  final DashboardStats stats;
  final int odometer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = context.spacing;
    final last = stats.lastRefuel;

    Widget bigValue(String value, String unit, {Color? color}) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: theme.textTheme.displayLarge
                    ?.copyWith(color: color ?? colors.primary),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(unit,
              style: context.textStyles.unitMono.copyWith(color: colors.outline)),
        ],
      );
    }

    final cards = [
      DashboardMetricCard(
        label: 'Consumo médio',
        child: bigValue(
          stats.averageConsumption == null
              ? '—'
              : Formatters.consumption(stats.averageConsumption!)
                  .replaceAll(' km/l', ''),
          'km/l',
        ),
      ),
      DashboardMetricCard(
        label: 'Gasto no mês',
        child: bigValue(
          Formatters.currency(stats.monthlySpend).replaceAll(RegExp(r'R\$\s?'), ''),
          'R\$',
        ),
      ),
      DashboardMetricCard(
        label: 'Último abastecimento',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              last == null ? '—' : Formatters.relativeDay(last.date),
              style: theme.textTheme.titleLarge?.copyWith(color: colors.primary),
            ),
            if (last != null)
              Text(Formatters.liters(last.liters),
                  style: context.textStyles.unitMono
                      .copyWith(color: colors.outline)),
          ],
        ),
      ),
      DashboardMetricCard(
        label: 'Hodômetro',
        child: bigValue(Formatters.odometer(odometer), 'km'),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: spacing.gutter,
      crossAxisSpacing: spacing.gutter,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cards,
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity({
    required this.entries,
    required this.onSeeAll,
    required this.onTapEntry,
    required this.onAddFirst,
  });

  final List<RefuelEntry> entries;
  final VoidCallback onSeeAll;
  final ValueChanged<String> onTapEntry;
  final VoidCallback onAddFirst;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = context.spacing;

    if (entries.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(spacing.stackLg),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLowest,
          borderRadius: context.radii.lgRadius,
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Column(
          children: [
            Text('Nenhum abastecimento ainda',
                style: theme.textTheme.titleMedium),
            SizedBox(height: spacing.stackSm),
            Text(
              'Registre o primeiro abastecimento deste veículo.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.stackMd),
            FilledButton.icon(
              onPressed: onAddFirst,
              icon: const Icon(Icons.add),
              label: const Text('Abastecer'),
            ),
          ],
        ),
      );
    }

    final recent = entries.take(5).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Atividade recente', style: theme.textTheme.titleLarge),
            TextButton(onPressed: onSeeAll, child: const Text('Ver tudo')),
          ],
        ),
        SizedBox(height: spacing.stackSm),
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: context.radii.lgRadius,
            border: Border.all(color: colors.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < recent.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                RefuelListTile(
                  entry: recent[i],
                  relativeDate: true,
                  onTap: () => onTapEntry(recent[i].refuel.id),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
