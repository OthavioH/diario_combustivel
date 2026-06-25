import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

@immutable
class AppRadii extends ThemeExtension<AppRadii> {
  const AppRadii({
    required this.sm,
    required this.base,
    required this.md,
    required this.lg,
    required this.xl,
    required this.full,
  });

  final double sm;

  final double base;

  final double md;

  final double lg;

  final double xl;

  final double full;

  static const AppRadii standard = AppRadii(
    sm: 2,
    base: 4,
    md: 6,
    lg: 8,
    xl: 12,
    full: 9999,
  );

  BorderRadius get smRadius => BorderRadius.circular(sm);
  BorderRadius get baseRadius => BorderRadius.circular(base);
  BorderRadius get mdRadius => BorderRadius.circular(md);
  BorderRadius get lgRadius => BorderRadius.circular(lg);
  BorderRadius get xlRadius => BorderRadius.circular(xl);
  BorderRadius get fullRadius => BorderRadius.circular(full);

  @override
  AppRadii copyWith({
    double? sm,
    double? base,
    double? md,
    double? lg,
    double? xl,
    double? full,
  }) {
    return AppRadii(
      sm: sm ?? this.sm,
      base: base ?? this.base,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      full: full ?? this.full,
    );
  }

  @override
  AppRadii lerp(covariant ThemeExtension<AppRadii>? other, double t) {
    if (other is! AppRadii) return this;
    return AppRadii(
      sm: lerpDouble(sm, other.sm, t)!,
      base: lerpDouble(base, other.base, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      full: lerpDouble(full, other.full, t)!,
    );
  }
}

extension RadiiContext on BuildContext {
  AppRadii get radii => Theme.of(this).extension<AppRadii>()!;
}
