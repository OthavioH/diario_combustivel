import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/theme.dart';

/// A large labelled number input with a unit affix, inside a bordered card —
/// the primary data inputs on the refuel form (valor, litros, quilometragem).
class RefuelBigField extends StatelessWidget {
  const RefuelBigField({
    super.key,
    required this.controller,
    required this.label,
    required this.unit,
    required this.validator,
    this.decimal = false,
    this.helper,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String label;
  final String unit;
  final FormFieldValidator<String> validator;
  final bool decimal;
  final String? helper;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.containerPadding),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: context.radii.lgRadius,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelMedium
                ?.copyWith(color: colors.onSurfaceVariant),
          ),
          SizedBox(height: spacing.stackSm / 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  autofocus: autofocus,
                  keyboardType:
                      TextInputType.numberWithOptions(decimal: decimal),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      decimal ? RegExp(r'[0-9.,]') : RegExp(r'[0-9]'),
                    ),
                  ],
                  style: theme.textTheme.displayLarge,
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    hintText: '0',
                  ),
                  validator: validator,
                ),
              ),
              SizedBox(width: spacing.gutter),
              Text(
                unit,
                style: context.textStyles.unitMono.copyWith(
                  color: colors.outline,
                ),
              ),
            ],
          ),
          if (helper != null) ...[
            SizedBox(height: spacing.stackSm / 2),
            Row(
              children: [
                Icon(Icons.history, size: 14, color: colors.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  helper!,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
