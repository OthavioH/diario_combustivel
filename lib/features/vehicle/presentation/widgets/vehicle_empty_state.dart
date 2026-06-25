import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

class VehicleEmptyState extends StatelessWidget {
  const VehicleEmptyState({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.containerPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.garage, size: 56, color: colors.outline),
            ),
            SizedBox(height: spacing.stackLg),
            Text(
              'Nenhum veículo ainda',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.stackSm),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                'Adicione seu primeiro veículo para começar a registrar abastecimentos.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: spacing.stackLg),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar veículo'),
            ),
          ],
        ),
      ),
    );
  }
}
