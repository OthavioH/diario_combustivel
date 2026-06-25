import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// A bordered metric tile on the vehicle dashboard. The caller supplies the
/// value area via [child] so each metric can lay its number/unit out freely.
class DashboardMetricCard extends StatelessWidget {
  const DashboardMetricCard({
    super.key,
    required this.label,
    required this.child,
    this.trailing,
  });

  final String label;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.gutter),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: context.radii.lgRadius,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              ),
              ?trailing,
            ],
          ),
          SizedBox(height: spacing.stackSm),
          child,
        ],
      ),
    );
  }
}
