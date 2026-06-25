import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/formatters.dart';

/// Live "Consumo estimado" readout shown above the save button on the form.
class ConsumptionPreviewBar extends StatelessWidget {
  const ConsumptionPreviewBar({super.key, required this.kmPerLiter});

  /// Estimated km/l, or null when there isn't enough data yet.
  final double? kmPerLiter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.containerPadding,
        vertical: spacing.gutter,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: context.radii.lgRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.speed, size: 20, color: colors.primary),
              SizedBox(width: spacing.stackSm),
              Text('Consumo estimado', style: theme.textTheme.bodyMedium),
            ],
          ),
          Text(
            kmPerLiter == null ? '--' : Formatters.consumption(kmPerLiter!),
            style: context.textStyles.unitMono.copyWith(
              color: kmPerLiter == null ? colors.onSurfaceVariant : colors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
