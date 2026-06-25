import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/refuel_calculations.dart';
import 'consumption_badge.dart';

/// A single refueling row, used by the dashboard's recent activity and the
/// history list: fuel icon, date + liters, amount + consumption badge.
class RefuelListTile extends StatelessWidget {
  const RefuelListTile({
    super.key,
    required this.entry,
    required this.onTap,
    this.relativeDate = false,
  });

  final RefuelEntry entry;
  final VoidCallback onTap;

  /// Show "há 2 dias" instead of an absolute date (dashboard recent activity).
  final bool relativeDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = context.spacing;
    final refuel = entry.refuel;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(spacing.containerPadding),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.local_gas_station, color: colors.onSurfaceVariant),
            ),
            SizedBox(width: spacing.gutter),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    relativeDate
                        ? Formatters.relativeDay(refuel.date)
                        : Formatters.shortDate(refuel.date),
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    Formatters.liters(refuel.liters),
                    style: context.textStyles.unitMono
                        .copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.currency(refuel.amountPaid),
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ConsumptionBadge(
                  kmPerLiter: entry.kmPerLiter,
                  trend: entry.trend,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
