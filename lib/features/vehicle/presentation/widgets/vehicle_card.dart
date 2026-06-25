import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/vehicle.dart';

enum VehicleCardAction { edit, delete }

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.accentIndex,
    required this.averageConsumption,
    required this.onTap,
    required this.onAction,
    required this.onLogRefuel,
  });

  final Vehicle vehicle;

  /// Position-based index used to alternate the avatar accent color.
  final int accentIndex;

  /// Average km/l for this vehicle, or null until it has enough refuelings.
  final double? averageConsumption;
  final VoidCallback onTap;
  final ValueChanged<VehicleCardAction> onAction;
  final VoidCallback onLogRefuel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = context.spacing;

    final avatarBackground = accentIndex.isEven
        ? colors.primaryContainer
        : colors.secondaryContainer;
    final avatarForeground = accentIndex.isEven
        ? colors.onPrimaryContainer
        : colors.onSecondaryContainer;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: context.radii.lgRadius,
        child: Padding(
          padding: EdgeInsets.all(spacing.containerPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: avatarBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(vehicle.type.icon, size: 22, color: avatarForeground),
                  ),
                  SizedBox(width: spacing.gutter),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.name,
                          style: theme.textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.local_gas_station,
                              size: 16,
                              color: colors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                vehicle.fuelType.label,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<VehicleCardAction>(
                    onSelected: onAction,
                    icon: Icon(Icons.more_vert, color: colors.onSurfaceVariant),
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: VehicleCardAction.edit,
                        child: Text('Editar'),
                      ),
                      PopupMenuItem(
                        value: VehicleCardAction.delete,
                        child: Text('Excluir'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: spacing.stackMd),
              const Divider(),
              SizedBox(height: spacing.stackMd),
              Row(
                children: [
                  Expanded(
                    child: _Stat(
                      label: 'HODÔMETRO',
                      value: Formatters.odometer(vehicle.currentMileage),
                      unit: 'km',
                    ),
                  ),
                  Expanded(
                    child: _Stat(
                      label: 'CONSUMO',
                      value: averageConsumption == null
                          ? '—'
                          : Formatters.consumption(averageConsumption!)
                              .replaceAll(' km/l', ''),
                      unit: 'km/l',
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.stackMd),
              Align(
                alignment: Alignment.centerRight,
                child: _LogRefuelButton(onPressed: onLogRefuel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.unit});

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: theme.textTheme.displayLarge),
              const SizedBox(width: 4),
              Text(
                unit,
                style: context.textStyles.unitMono.copyWith(
                  color: colors.outline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LogRefuelButton extends StatelessWidget {
  const _LogRefuelButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add, size: 18),
      label: const Text('Abastecer'),
      style: TextButton.styleFrom(
        backgroundColor: colors.surfaceContainerLow,
        foregroundColor: colors.primary,
        minimumSize: const Size(0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
      ),
    );
  }
}
