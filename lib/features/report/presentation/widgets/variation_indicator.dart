import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/formatters.dart';

/// Period-over-period change: ▲ red when up (worse), ▼ green when down (better).
/// Renders nothing when there's no comparable previous period.
class VariationIndicator extends StatelessWidget {
  const VariationIndicator({
    super.key,
    required this.fraction,
    required this.comparedTo,
  });

  /// Signed change as a fraction (e.g. 0.024 = +2.4%), or null to hide.
  final double? fraction;

  /// Trailing context, e.g. "mês anterior".
  final String comparedTo;

  @override
  Widget build(BuildContext context) {
    if (fraction == null) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;

    final isUp = fraction! > 0;
    final color = isUp ? colors.error : colors.secondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isUp ? Icons.trending_up : Icons.trending_down,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          '${Formatters.percent(fraction!)} vs $comparedTo',
          style: context.textStyles.unitMono.copyWith(color: color),
        ),
      ],
    );
  }
}
