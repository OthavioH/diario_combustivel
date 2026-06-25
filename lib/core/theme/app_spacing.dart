import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    required this.touchTarget,
    required this.containerPadding,
    required this.stackSm,
    required this.stackMd,
    required this.stackLg,
    required this.gutter,
  });

  final double touchTarget;

  final double containerPadding;

  final double stackSm;

  final double stackMd;

  final double stackLg;

  final double gutter;

  static const AppSpacing standard = AppSpacing(
    touchTarget: 48,
    containerPadding: 16,
    stackSm: 8,
    stackMd: 16,
    stackLg: 24,
    gutter: 12,
  );

  @override
  AppSpacing copyWith({
    double? touchTarget,
    double? containerPadding,
    double? stackSm,
    double? stackMd,
    double? stackLg,
    double? gutter,
  }) {
    return AppSpacing(
      touchTarget: touchTarget ?? this.touchTarget,
      containerPadding: containerPadding ?? this.containerPadding,
      stackSm: stackSm ?? this.stackSm,
      stackMd: stackMd ?? this.stackMd,
      stackLg: stackLg ?? this.stackLg,
      gutter: gutter ?? this.gutter,
    );
  }

  @override
  AppSpacing lerp(covariant ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) return this;
    return AppSpacing(
      touchTarget: lerpDouble(touchTarget, other.touchTarget, t)!,
      containerPadding:
          lerpDouble(containerPadding, other.containerPadding, t)!,
      stackSm: lerpDouble(stackSm, other.stackSm, t)!,
      stackMd: lerpDouble(stackMd, other.stackMd, t)!,
      stackLg: lerpDouble(stackLg, other.stackLg, t)!,
      gutter: lerpDouble(gutter, other.gutter, t)!,
    );
  }
}

extension SpacingContext on BuildContext {
  AppSpacing get spacing => Theme.of(this).extension<AppSpacing>()!;
}
