import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../providers/report_providers.dart';
import '../report_calculations.dart';
import '../widgets/efficiency_comparison.dart';
import '../widgets/key_stat_card.dart';
import '../widgets/monthly_spending_chart.dart';
import '../widgets/variation_indicator.dart';

/// Reports tab — spending and efficiency across all vehicles.
class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final data = ref.watch(reportDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios')),
      body: data.hasData
          ? ListView(
              padding: EdgeInsets.all(spacing.containerPadding),
              children: [
                _KeyStats(data: data),
                SizedBox(height: spacing.stackLg),
                _Section(
                  title: 'Gasto mensal',
                  child: Column(
                    children: [
                      MonthlySpendingChart(series: data.monthlySeries),
                      SizedBox(height: spacing.stackMd),
                      const Divider(),
                      SizedBox(height: spacing.stackSm),
                      _TotalRow(total: data.sixMonthTotal),
                    ],
                  ),
                ),
                SizedBox(height: spacing.stackLg),
                _Section(
                  title: 'Comparação de eficiência',
                  child: EfficiencyComparison(items: data.efficiency),
                ),
              ],
            )
          : const _EmptyReport(),
    );
  }
}

class _KeyStats extends StatelessWidget {
  const _KeyStats({required this.data});

  final ReportData data;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: KeyStatCard(
              icon: Icons.payments_outlined,
              label: 'Custo médio/km',
              value: data.avgCostPerKm == null
                  ? '—'
                  : Formatters.currency(data.avgCostPerKm!),
              variation: VariationIndicator(
                fraction: data.costPerKmVariation,
                comparedTo: 'mês anterior',
              ),
            ),
          ),
          SizedBox(width: spacing.gutter),
          Expanded(
            child: KeyStatCard(
              icon: Icons.calendar_today_outlined,
              label: 'Gasto no ano',
              value: Formatters.currency(data.yearlySpend),
              variation: VariationIndicator(
                fraction: data.yearlyVariation,
                comparedTo: 'ano anterior',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.containerPadding),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: context.radii.xlRadius,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                theme.textTheme.titleLarge?.copyWith(color: colors.primary),
          ),
          SizedBox(height: spacing.stackMd),
          child,
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total dos últimos 6 meses',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        Text(Formatters.currency(total), style: theme.textTheme.titleLarge),
      ],
    );
  }
}

class _EmptyReport extends StatelessWidget {
  const _EmptyReport();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = context.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.containerPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insert_chart_outlined,
                size: 56, color: colors.onSurfaceVariant),
            SizedBox(height: spacing.stackMd),
            Text('Sem dados ainda', style: theme.textTheme.titleMedium),
            SizedBox(height: spacing.stackSm),
            Text(
              'Registre abastecimentos para ver seus relatórios.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
