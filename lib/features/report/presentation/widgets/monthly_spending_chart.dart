import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../report_calculations.dart';

/// Bar chart of spend over the last months; the most recent bar is highlighted.
class MonthlySpendingChart extends StatelessWidget {
  const MonthlySpendingChart({super.key, required this.series});

  final List<MonthlySpend> series;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final maxTotal =
        series.fold<double>(0, (m, s) => s.total > m ? s.total : m);
    final maxY = maxTotal <= 0 ? 1.0 : maxTotal * 1.2;
    final lastIndex = series.length - 1;

    return SizedBox(
      height: 192,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => colors.inverseSurface,
              getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                Formatters.currency(rod.toY),
                context.textStyles.unitMono
                    .copyWith(color: colors.onInverseSurface),
              ),
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= series.length) {
                    return const SizedBox.shrink();
                  }
                  final isLast = i == lastIndex;
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      Formatters.monthAbbrev(series[i].month),
                      style: context.textStyles.unitMono.copyWith(
                        color: isLast ? colors.primary : colors.onSurfaceVariant,
                        fontWeight: isLast ? FontWeight.bold : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < series.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: series[i].total,
                    color: i == lastIndex
                        ? colors.primary
                        : colors.primaryContainer,
                    width: 18,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(2),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
