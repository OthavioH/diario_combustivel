import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography for the Fuel Diary design system.
///
/// The UI typeface is **Inter** (loaded via `google_fonts`); technical data
/// units use **JetBrains Mono** (see [AppTextStyles.unitMono]).
///
/// The DESIGN.md type scale is mapped onto the closest Material 3 [TextTheme]
/// slots so that standard widgets pick up the correct font, size and weight
/// automatically. The design's own named styles (display-data, label-caps,
/// unit-mono…) are additionally exposed via the `AppTextStyles` theme
/// extension for features that want to reference the design vocabulary directly.
///
/// In Flutter, `TextStyle.height` is a multiplier (lineHeight / fontSize) and
/// `letterSpacing` is in logical pixels (em * fontSize).
abstract final class AppTypography {
  /// Base font family name for Inter, for places that need the raw family.
  static String get interFamily => GoogleFonts.inter().fontFamily!;

  /// Base font family name for JetBrains Mono.
  static String get jetBrainsMonoFamily =>
      GoogleFonts.jetBrainsMono().fontFamily!;

  /// The full M3 [TextTheme] with Inter applied and the design scale mapped on.
  static TextTheme get textTheme {
    // Start from Inter applied across every default M3 slot, then override the
    // slots the design system specifies explicitly.
    final base = GoogleFonts.interTextTheme();

    return base.copyWith(
      // display-data: 32 / 700 / lh 40 / -0.02em
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.02 * 32,
      ),
      // headline-lg: 24 / 600 / lh 32
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
      ),
      // headline-md: 20 / 600 / lh 28
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
      ),
      // body-lg: 16 / 400 / lh 24
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
      ),
      // body-md: 14 / 400 / lh 20
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      ),
      // label-caps: 12 / 600 / lh 16 / 0.05em
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        letterSpacing: 0.05 * 12,
      ),
    );
  }
}
