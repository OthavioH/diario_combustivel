import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../refuel/presentation/providers/refuel_providers.dart';
import '../../domain/entities/vehicle.dart';
import '../providers/vehicle_providers.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicle_empty_state.dart';

class VehicleListScreen extends ConsumerWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final vehiclesAsync = ref.watch(vehicleListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tanque Cheio',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.containerPadding,
              spacing.stackMd,
              spacing.containerPadding,
              spacing.stackSm,
            ),
            child: Text('Seus Veículos', style: theme.textTheme.titleLarge),
          ),
          Expanded(
            child: vehiclesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _ErrorView(
                onRetry: () => ref.invalidate(vehicleListProvider),
              ),
              data: (vehicles) {
                if (vehicles.isEmpty) {
                  return VehicleEmptyState(
                    onAdd: () => context.pushVehicleForm(),
                  );
                }
                return _VehicleList(vehicles: vehicles);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushVehicleForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _VehicleList extends ConsumerWidget {
  const _VehicleList({required this.vehicles});

  final List<Vehicle> vehicles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        spacing.containerPadding,
        0,
        spacing.containerPadding,
        spacing.containerPadding,
      ),
      itemCount: vehicles.length,
      separatorBuilder: (_, _) => SizedBox(height: spacing.stackMd),
      itemBuilder: (context, index) {
        final vehicle = vehicles[index];
        return VehicleCard(
          vehicle: vehicle,
          accentIndex: index,
          averageConsumption:
              ref.watch(vehicleAverageConsumptionProvider(vehicle.id)),
          onTap: () => context.pushVehicleDashboard(vehicle.id),
          onAction: (action) => _onAction(context, ref, vehicle, action),
          onLogRefuel: () => context.pushNewRefuel(vehicle.id),
        );
      },
    );
  }

  Future<void> _onAction(
    BuildContext context,
    WidgetRef ref,
    Vehicle vehicle,
    VehicleCardAction action,
  ) async {
    switch (action) {
      case VehicleCardAction.edit:
        context.pushVehicleForm(vehicleId: vehicle.id);
      case VehicleCardAction.delete:
        await _confirmAndDelete(context, ref, vehicle);
    }
  }

  Future<void> _confirmAndDelete(
    BuildContext context,
    WidgetRef ref,
    Vehicle vehicle,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir veículo'),
        content: Text('Deseja excluir "${vehicle.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      // Cascade: drop the vehicle's refuelings, then the vehicle.
      await ref.read(refuelListProvider.notifier).removeForVehicle(vehicle.id);
      await ref.read(vehicleListProvider.notifier).remove(vehicle.id);
    }
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Não foi possível carregar os veículos.'),
          SizedBox(height: spacing.stackMd),
          OutlinedButton(onPressed: onRetry, child: const Text('Tentar novamente')),
        ],
      ),
    );
  }
}
