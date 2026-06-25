import 'package:flutter/material.dart';

import 'app_color_scheme.dart';
import 'app_radii.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(AppColorScheme.light);

  static ThemeData _build(ColorScheme colorScheme) {
    const radii = AppRadii.standard;
    const spacing = AppSpacing.standard;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      extensions: <ThemeExtension<dynamic>>[
        spacing,
        radii,
        AppTextStyles.standard,
      ],

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        shape: const StadiumBorder(),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: Size(0, spacing.touchTarget),
          shape: const StadiumBorder(),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(0, spacing.touchTarget),
          shape: const StadiumBorder(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: Size(0, spacing.touchTarget),
          shape: const StadiumBorder(),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: Size(0, spacing.touchTarget),
          shape: const StadiumBorder(),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing.containerPadding,
          vertical: spacing.gutter,
        ),
        border: OutlineInputBorder(
          borderRadius: radii.lgRadius,
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radii.lgRadius,
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radii.lgRadius,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radii.lgRadius,
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),

      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radii.lgRadius,
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerHigh,
          selectedBackgroundColor: colorScheme.surfaceContainerLowest,
          selectedForegroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: radii.lgRadius),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: const StadiumBorder(),
      ),
    );
  }

}
