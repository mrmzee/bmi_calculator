import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/tokens/app_colors.dart';

/// Cool studio surfaces that sit beside the Material color scheme.
final class AppCanvas extends ThemeExtension<AppCanvas> {
  const AppCanvas({
    required this.canvas,
    required this.panel,
    required this.field,
    required this.accent,
    required this.glow,
    required this.glowAlt,
    required this.hairline,
  });

  final Color canvas;
  final Color panel;
  final Color field;
  final Color accent;
  final Color glow;
  final Color glowAlt;
  final Color hairline;

  static const light = AppCanvas(
    canvas: AppColors.canvasLight,
    panel: AppColors.panelLight,
    field: AppColors.fieldLight,
    accent: AppColors.accentLight,
    glow: AppColors.glowLight,
    glowAlt: AppColors.glowAltLight,
    hairline: AppColors.hairlineLight,
  );

  static const dark = AppCanvas(
    canvas: AppColors.canvasDark,
    panel: AppColors.panelDark,
    field: AppColors.fieldDark,
    accent: AppColors.accentDark,
    glow: AppColors.glowDark,
    glowAlt: AppColors.glowAltDark,
    hairline: AppColors.hairlineDark,
  );

  @override
  AppCanvas copyWith({
    Color? canvas,
    Color? panel,
    Color? field,
    Color? accent,
    Color? glow,
    Color? glowAlt,
    Color? hairline,
  }) {
    return AppCanvas(
      canvas: canvas ?? this.canvas,
      panel: panel ?? this.panel,
      field: field ?? this.field,
      accent: accent ?? this.accent,
      glow: glow ?? this.glow,
      glowAlt: glowAlt ?? this.glowAlt,
      hairline: hairline ?? this.hairline,
    );
  }

  @override
  AppCanvas lerp(AppCanvas? other, double t) {
    if (other is! AppCanvas) {
      return this;
    }
    return AppCanvas(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      panel: Color.lerp(panel, other.panel, t)!,
      field: Color.lerp(field, other.field, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      glow: Color.lerp(glow, other.glow, t)!,
      glowAlt: Color.lerp(glowAlt, other.glowAlt, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
    );
  }
}

extension AppCanvasContext on BuildContext {
  AppCanvas get appCanvas {
    return Theme.of(this).extension<AppCanvas>() ?? AppCanvas.light;
  }
}
