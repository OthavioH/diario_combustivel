import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Spacing scale from the Fuel Diary design system, exposed as a
/// [ThemeExtension] so widgets read it via `Theme.of(context)` (or the
/// [SpacingContext] shortcut below) and it can vary per theme/brightness.
///
/// Values mirror DESIGN.md's spacing tokens (an 8px-based scale).
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

  /// Minimum interactive target size for one-handed mobile use.
  final double touchTarget;

  /// Horizontal padding for main content (safe gutters).
  final double containerPadding;

  /// Minimal vertical spacing.
  final double stackSm;

  /// Standard vertical spacing.
  final double stackMd;

  /// Large vertical spacing.
  final double stackLg;

  /// Horizontal gap between inline elements.
  final double gutter;

  /// The canonical spacing scale used by the app.
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

/// Convenience accessor: `context.spacing.stackMd`.
extension SpacingContext on BuildContext {
  AppSpacing get spacing => Theme.of(this).extension<AppSpacing>()!;
}
