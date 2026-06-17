import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design-specific named text styles exposed as a [ThemeExtension].
///
/// These mirror the DESIGN.md type vocabulary so feature code can reference
/// styles by their design names (e.g. `context.textStyles.unitMono`). The
/// standard M3 slots are still available via `Theme.of(context).textTheme`
/// (see [AppTypography]); this extension is for the styles M3 has no slot for —
/// notably [unitMono] (JetBrains Mono for data units like `L`, `km`, `R$`).
@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.displayData,
    required this.labelCaps,
    required this.unitMono,
  });

  /// display-data: Inter 32 / 700 / lh 40 / -0.02em — big headline metrics.
  final TextStyle displayData;

  /// label-caps: Inter 12 / 600 / lh 16 / 0.05em — uppercase-style labels.
  final TextStyle labelCaps;

  /// unit-mono: JetBrains Mono 12 / 500 / lh 16 — units beside data values.
  final TextStyle unitMono;

  /// The canonical set of design text styles.
  static AppTextStyles get standard => AppTextStyles(
        displayData: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 40 / 32,
          letterSpacing: -0.02 * 32,
        ),
        labelCaps: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 16 / 12,
          letterSpacing: 0.05 * 12,
        ),
        unitMono: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 16 / 12,
        ),
      );

  @override
  AppTextStyles copyWith({
    TextStyle? displayData,
    TextStyle? labelCaps,
    TextStyle? unitMono,
  }) {
    return AppTextStyles(
      displayData: displayData ?? this.displayData,
      labelCaps: labelCaps ?? this.labelCaps,
      unitMono: unitMono ?? this.unitMono,
    );
  }

  @override
  AppTextStyles lerp(covariant ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
      displayData: TextStyle.lerp(displayData, other.displayData, t)!,
      labelCaps: TextStyle.lerp(labelCaps, other.labelCaps, t)!,
      unitMono: TextStyle.lerp(unitMono, other.unitMono, t)!,
    );
  }
}

/// Convenience accessor: `context.textStyles.unitMono`.
extension TextStylesContext on BuildContext {
  AppTextStyles get textStyles => Theme.of(this).extension<AppTextStyles>()!;
}
