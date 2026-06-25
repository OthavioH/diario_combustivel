import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/fuel_type.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../vehicle/domain/entities/vehicle.dart';
import '../../../vehicle/presentation/providers/vehicle_providers.dart';
import '../../domain/refuel_calculations.dart';
import '../providers/refuel_providers.dart';
import '../widgets/refuel_list_tile.dart';

enum _Period {
  all('Todo período'),
  thisMonth('Este mês');

  const _Period(this.label);
  final String label;
}

/// History tab — every refueling across vehicles, grouped by month, filterable
/// by vehicle, period and fuel type.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String? _vehicleId; // null = all
  _Period _period = _Period.all;
  FuelType? _fuelType; // null = all

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final vehicles = ref.watch(vehicleListProvider).value ?? const [];
    final allRefuels = ref.watch(refuelListProvider).value ?? const [];

    // Consumption is per-vehicle, so compute entries within each vehicle's full
    // history first, then filter the resulting entries for display.
    final entries = <RefuelEntry>[];
    for (final vehicle in vehicles) {
      final vehicleRefuels =
          allRefuels.where((r) => r.vehicleId == vehicle.id).toList();
      entries.addAll(RefuelCalculations.withConsumption(vehicleRefuels));
    }

    final now = DateTime.now();
    final filtered = entries.where((e) {
      final r = e.refuel;
      if (_vehicleId != null && r.vehicleId != _vehicleId) return false;
      if (_fuelType != null && r.fuelType != _fuelType) return false;
      if (_period == _Period.thisMonth &&
          (r.date.year != now.year || r.date.month != now.month)) {
        return false;
      }
      return true;
    }).toList()
      ..sort((a, b) => b.refuel.date.compareTo(a.refuel.date));

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.containerPadding,
              vertical: spacing.stackSm,
            ),
            child: Wrap(
              spacing: spacing.gutter,
              runSpacing: spacing.stackSm,
              children: [
                _FilterChip(
                  label: _vehicleId == null
                      ? 'Todos os veículos'
                      : vehicles
                              .where((v) => v.id == _vehicleId)
                              .firstOrNull
                              ?.name ??
                          'Veículo',
                  onSelected: () => _pickVehicle(vehicles),
                ),
                _FilterChip(
                  label: _period.label,
                  onSelected: _pickPeriod,
                ),
                _FilterChip(
                  label: _fuelType?.label ?? 'Todos os combustíveis',
                  onSelected: _pickFuel,
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const _EmptyHistory()
                : _GroupedList(
                    entries: filtered,
                    onTap: (e) => context.pushRefuelEdit(
                      e.refuel.vehicleId,
                      e.refuel.id,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickVehicle(List<Vehicle> vehicles) async {
    final selected = await showModalBottomSheet<_Selection<String?>>(
      context: context,
      builder: (context) => _OptionSheet<String?>(
        title: 'Veículo',
        options: [
          const _Option(null, 'Todos os veículos'),
          for (final v in vehicles) _Option(v.id, v.name),
        ],
        current: _vehicleId,
      ),
    );
    if (selected != null) setState(() => _vehicleId = selected.value);
  }

  Future<void> _pickPeriod() async {
    final selected = await showModalBottomSheet<_Selection<_Period>>(
      context: context,
      builder: (context) => _OptionSheet<_Period>(
        title: 'Período',
        options: [for (final p in _Period.values) _Option(p, p.label)],
        current: _period,
      ),
    );
    if (selected != null) setState(() => _period = selected.value);
  }

  Future<void> _pickFuel() async {
    final selected = await showModalBottomSheet<_Selection<FuelType?>>(
      context: context,
      builder: (context) => _OptionSheet<FuelType?>(
        title: 'Combustível',
        options: [
          const _Option(null, 'Todos os combustíveis'),
          for (final f in FuelType.values) _Option(f, f.label),
        ],
        current: _fuelType,
      ),
    );
    if (selected != null) setState(() => _fuelType = selected.value);
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.onSelected});

  final String label;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      avatar: const Icon(Icons.arrow_drop_down, size: 18),
      onPressed: onSelected,
    );
  }
}

/// Wrapper so a `null` selection is distinguishable from a dismissed sheet.
class _Selection<T> {
  const _Selection(this.value);
  final T value;
}

class _Option<T> {
  const _Option(this.value, this.label);
  final T value;
  final String label;
}

class _OptionSheet<T> extends StatelessWidget {
  const _OptionSheet({
    required this.title,
    required this.options,
    required this.current,
  });

  final String title;
  final List<_Option<T>> options;
  final T current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(spacing.containerPadding),
            child: Text(title, style: theme.textTheme.titleMedium),
          ),
          for (final option in options)
            ListTile(
              title: Text(option.label),
              trailing: option.value == current
                  ? Icon(Icons.check, color: theme.colorScheme.primary)
                  : null,
              onTap: () =>
                  Navigator.of(context).pop(_Selection<T>(option.value)),
            ),
          SizedBox(height: spacing.stackSm),
        ],
      ),
    );
  }
}

class _GroupedList extends StatelessWidget {
  const _GroupedList({required this.entries, required this.onTap});

  final List<RefuelEntry> entries;
  final ValueChanged<RefuelEntry> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = context.spacing;

    // Build a flat list of section headers + grouped tile cards.
    final children = <Widget>[];
    var currentMonth = '';
    var groupStart = 0;
    void flushGroup(int end) {
      if (end <= groupStart) return;
      final group = entries.sublist(groupStart, end);
      children.add(
        Container(
          margin: EdgeInsets.only(bottom: spacing.stackMd),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: context.radii.lgRadius,
            border: Border.all(color: colors.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < group.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                RefuelListTile(entry: group[i], onTap: () => onTap(group[i])),
              ],
            ],
          ),
        ),
      );
    }

    for (var i = 0; i < entries.length; i++) {
      final month = Formatters.monthYear(entries[i].refuel.date);
      if (month != currentMonth) {
        flushGroup(i);
        groupStart = i;
        currentMonth = month;
        children.add(Padding(
          padding: EdgeInsets.only(bottom: spacing.stackSm, top: spacing.stackSm),
          child: Text(month,
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: colors.onSurfaceVariant)),
        ));
      }
    }
    flushGroup(entries.length);

    return ListView(
      padding: EdgeInsets.all(spacing.containerPadding),
      children: children,
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = context.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.containerPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_gas_station_outlined,
                size: 56, color: colors.onSurfaceVariant),
            SizedBox(height: spacing.stackMd),
            Text('Nenhum abastecimento', style: theme.textTheme.titleMedium),
            SizedBox(height: spacing.stackSm),
            Text(
              'Os abastecimentos registrados aparecem aqui.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
