import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Material 3 [ColorScheme]s built from the Fuel Diary design tokens.
///
/// Each token from [AppColors] is mapped to its M3 `ColorScheme` slot by hand
/// (rather than via `ColorScheme.fromSeed`) so the palette matches DESIGN.md
/// exactly.
abstract final class AppColorScheme {
  /// The light color scheme — the only scheme wired into the app today.
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,

    // Primary — Gasoline Blue
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    primaryFixed: AppColors.primaryFixed,
    primaryFixedDim: AppColors.primaryFixedDim,
    onPrimaryFixed: AppColors.onPrimaryFixed,
    onPrimaryFixedVariant: AppColors.onPrimaryFixedVariant,

    // Secondary — Efficiency Green
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    secondaryFixed: AppColors.secondaryFixed,
    secondaryFixedDim: AppColors.secondaryFixedDim,
    onSecondaryFixed: AppColors.onSecondaryFixed,
    onSecondaryFixedVariant: AppColors.onSecondaryFixedVariant,

    // Tertiary — Amber / Warning
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    tertiaryFixed: AppColors.tertiaryFixed,
    tertiaryFixedDim: AppColors.tertiaryFixedDim,
    onTertiaryFixed: AppColors.onTertiaryFixed,
    onTertiaryFixedVariant: AppColors.onTertiaryFixedVariant,

    // Error
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,

    // Surfaces
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceDim: AppColors.surfaceDim,
    surfaceBright: AppColors.surfaceBright,
    surfaceContainerLowest: AppColors.surfaceContainerLowest,
    surfaceContainerLow: AppColors.surfaceContainerLow,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    onSurfaceVariant: AppColors.onSurfaceVariant,

    // Outlines & tint
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    surfaceTint: AppColors.surfaceTint,

    // Inverse
    inverseSurface: AppColors.inverseSurface,
    onInverseSurface: AppColors.inverseOnSurface,
    inversePrimary: AppColors.inversePrimary,

    // Scrim / shadow use the M3 defaults (opaque black).
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  // ---------------------------------------------------------------------------
  // Dark color scheme — TODO
  // ---------------------------------------------------------------------------
  // Dark mode is structurally supported but not yet used. When implementing it,
  // add:
  //
  //   static const ColorScheme dark = ColorScheme(
  //     brightness: Brightness.dark,
  //     ...dark tokens from AppColors...
  //   );
  //
  // and wire it into `AppTheme.dark` + `MaterialApp.darkTheme`.
}
