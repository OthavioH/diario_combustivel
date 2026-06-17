import 'package:flutter/material.dart';

/// Raw color tokens for the Fuel Diary design system.
///
/// Values are transcribed verbatim from `.tmp/theme_description/DESIGN.md`.
/// This single named palette is the source for the **light** color scheme.
/// Do not re-derive these with `ColorScheme.fromSeed` — they are intentional.
///
/// When dark mode is implemented, add a parallel `AppColorsDark` (or a `_Dark`
/// section) and wire it into [AppColorScheme.dark]. See the placeholder below.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Surface family
  // ---------------------------------------------------------------------------
  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceDim = Color(0xFFD9DADB);
  static const Color surfaceBright = Color(0xFFF8F9FA);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F4F5);
  static const Color surfaceContainer = Color(0xFFEDEEEF);
  static const Color surfaceContainerHigh = Color(0xFFE7E8E9);
  static const Color surfaceContainerHighest = Color(0xFFE1E3E4);
  static const Color surfaceVariant = Color(0xFFE1E3E4);

  // ---------------------------------------------------------------------------
  // Text & contrast
  // ---------------------------------------------------------------------------
  static const Color onSurface = Color(0xFF191C1D);
  static const Color onSurfaceVariant = Color(0xFF43474E);

  // ---------------------------------------------------------------------------
  // Background
  // ---------------------------------------------------------------------------
  static const Color background = Color(0xFFF8F9FA);
  static const Color onBackground = Color(0xFF191C1D);

  // ---------------------------------------------------------------------------
  // Inverse
  // ---------------------------------------------------------------------------
  static const Color inverseSurface = Color(0xFF2E3132);
  static const Color inverseOnSurface = Color(0xFFF0F1F2);
  static const Color inversePrimary = Color(0xFFABC8F4);

  // ---------------------------------------------------------------------------
  // Outlines & tint
  // ---------------------------------------------------------------------------
  static const Color outline = Color(0xFF73777F);
  static const Color outlineVariant = Color(0xFFC3C6CF);
  static const Color surfaceTint = Color(0xFF426086);

  // ---------------------------------------------------------------------------
  // Primary — Gasoline Blue
  // ---------------------------------------------------------------------------
  static const Color primary = Color(0xFF002547);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF1B3B5F);
  static const Color onPrimaryContainer = Color(0xFF88A6CF);
  static const Color primaryFixed = Color(0xFFD3E4FF);
  static const Color primaryFixedDim = Color(0xFFABC8F4);
  static const Color onPrimaryFixed = Color(0xFF001C38);
  static const Color onPrimaryFixedVariant = Color(0xFF2A486D);

  // ---------------------------------------------------------------------------
  // Secondary — Efficiency Green
  // ---------------------------------------------------------------------------
  static const Color secondary = Color(0xFF2C694E);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFAEEECB);
  static const Color onSecondaryContainer = Color(0xFF316E52);
  static const Color secondaryFixed = Color(0xFFB1F0CE);
  static const Color secondaryFixedDim = Color(0xFF95D4B3);
  static const Color onSecondaryFixed = Color(0xFF002114);
  static const Color onSecondaryFixedVariant = Color(0xFF0E5138);

  // ---------------------------------------------------------------------------
  // Tertiary — Amber / Warning
  // ---------------------------------------------------------------------------
  static const Color tertiary = Color(0xFF322100);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF4E3500);
  static const Color onTertiaryContainer = Color(0xFFD59800);
  static const Color tertiaryFixed = Color(0xFFFFDEA9);
  static const Color tertiaryFixedDim = Color(0xFFFFBA27);
  static const Color onTertiaryFixed = Color(0xFF271900);
  static const Color onTertiaryFixedVariant = Color(0xFF5E4100);

  // ---------------------------------------------------------------------------
  // Error
  // ---------------------------------------------------------------------------
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ---------------------------------------------------------------------------
  // Dark palette — TODO
  // ---------------------------------------------------------------------------
  // Dark mode is structurally supported but not yet used. When implementing it,
  // add dark token constants here (or in a sibling `AppColorsDark` class) and
  // build `AppColorScheme.dark` from them. The inverse* tokens above are a
  // useful starting point.
}
