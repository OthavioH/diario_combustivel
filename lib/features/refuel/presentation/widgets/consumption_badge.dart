import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/refuel_calculations.dart';

/// A km/l chip colored by trend (green up / red down / neutral). Renders nothing
/// when consumption isn't available (the first stop of a vehicle).
class ConsumptionBadge extends StatelessWidget {
  const ConsumptionBadge({
    super.key,
    required this.kmPerLiter,
    required this.trend,
  });

  final double? kmPerLiter;
  final ConsumptionTrend trend;

  @override
  Widget build(BuildContext context) {
    if (kmPerLiter == null) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;

    final (background, foreground, icon) = switch (trend) {
      ConsumptionTrend.up => (
          colors.secondaryContainer,
          colors.onSecondaryContainer,
          Icons.trending_up,
        ),
      ConsumptionTrend.down => (
          colors.errorContainer,
          colors.onErrorContainer,
          Icons.trending_down,
        ),
      ConsumptionTrend.flat => (
          colors.surfaceContainerHigh,
          colors.onSurfaceVariant,
          null,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: context.radii.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            Formatters.consumption(kmPerLiter!),
            style: context.textStyles.unitMono.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
