import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.displayData,
    required this.labelCaps,
    required this.unitMono,
  });

  final TextStyle displayData;

  final TextStyle labelCaps;

  final TextStyle unitMono;

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

extension TextStylesContext on BuildContext {
  AppTextStyles get textStyles => Theme.of(this).extension<AppTextStyles>()!;
}
