import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../report_calculations.dart';

/// Per-vehicle average efficiency, ranked, each as a proportional bar (best in
/// efficiency-green). Vehicles without enough data show "—" and no bar.
class EfficiencyComparison extends StatelessWidget {
  const EfficiencyComparison({super.key, required this.items});

  final List<VehicleEfficiency> items;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    final best = items
        .map((e) => e.kmPerLiter ?? 0)
        .fold<double>(0, (m, v) => v > m ? v : m);

    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) SizedBox(height: spacing.stackMd),
          _EfficiencyRow(item: items[i], best: best, isBest: i == 0 && best > 0),
        ],
      ],
    );
  }
}

class _EfficiencyRow extends StatelessWidget {
  const _EfficiencyRow({
    required this.item,
    required this.best,
    required this.isBest,
  });

  final VehicleEfficiency item;
  final double best;
  final bool isBest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final value = item.kmPerLiter;
    final fraction = (value != null && best > 0) ? (value / best) : 0.0;
    final barColor = isBest ? colors.secondary : colors.outline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                item.vehicle.name,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              value == null ? '—' : Formatters.consumption(value),
              style: context.textStyles.unitMono.copyWith(
                color: isBest ? colors.secondary : colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: context.radii.fullRadius,
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 8,
            backgroundColor: colors.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation(barColor),
          ),
        ),
      ],
    );
  }
}
