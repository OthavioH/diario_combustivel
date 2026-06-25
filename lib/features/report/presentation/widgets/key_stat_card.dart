import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// A headline KPI card: icon + label, a big value, and an optional variation row.
class KeyStatCard extends StatelessWidget {
  const KeyStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.variation,
  });

  final IconData icon;
  final String label;
  final String value;
  final Widget? variation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.containerPadding),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: context.radii.xlRadius,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: colors.onSurfaceVariant),
              SizedBox(width: spacing.stackSm),
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.stackSm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: theme.textTheme.displayLarge),
          ),
          if (variation != null) ...[
            SizedBox(height: spacing.stackSm),
            variation!,
          ],
        ],
      ),
    );
  }
}
