import 'package:flutter/material.dart';

import 'app_color_scheme.dart';
import 'app_radii.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';
import 'app_typography.dart';

/// Central assembly point for the Fuel Diary [ThemeData].
///
/// Combines the design-system color scheme ([AppColorScheme]), typography
/// ([AppTypography]) and custom token extensions ([AppSpacing], [AppRadii],
/// [AppTextStyles]) into a single Material 3 theme, then tunes the component
/// themes to match the stitch designs (pill buttons/FAB, outlined inputs,
/// bordered white cards, 1px dividers).
///
/// Only [light] is wired into the app today; [dark] is reserved for later.
abstract final class AppTheme {
  /// The light theme — the active theme for the app.
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

      // Pill FAB in Efficiency Green.
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        shape: const StadiumBorder(),
      ),

      // Primary CTAs: pill-shaped, full touch-target height.
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

      // Outlined inputs with a permanent outline-variant border.
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

      // White cards with a 1px outline-variant border, minimal elevation.
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

      // 1px separators.
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Flat app bar sitting on the background.
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),

      // Bottom navigation with a subtle selected-state container.
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // Segmented control for fuel types (95, 98, Diesel).
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerHigh,
          selectedBackgroundColor: colorScheme.surfaceContainerLowest,
          selectedForegroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: radii.lgRadius),
        ),
      ),

      // Pill filter chips.
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: const StadiumBorder(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Dark theme — TODO
  // ---------------------------------------------------------------------------
  // Dark mode is structurally supported but not yet used. Once
  // `AppColorScheme.dark` exists, implement:
  //
  //   static ThemeData get dark => _build(AppColorScheme.dark);
  //
  // then wire it into `MaterialApp.darkTheme`. Until then the app forces light.
}
