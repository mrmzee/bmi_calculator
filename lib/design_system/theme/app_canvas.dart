import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/tokens/app_colors.dart';

/// Warm studio surfaces that sit beside the Material color scheme.
final class AppCanvas extends ThemeExtension<AppCanvas> {
  const AppCanvas({
    required this.canvas,
    required this.panel,
    required this.field,
    required this.brass,
    required this.glow,
    required this.hairline,
  });

  final Color canvas;
  final Color panel;
  final Color field;
  final Color brass;
  final Color glow;
  final Color hairline;

  static const light = AppCanvas(
    canvas: AppColors.canvasLight,
    panel: AppColors.panelLight,
    field: AppColors.fieldLight,
    brass: AppColors.brassLight,
    glow: AppColors.glowLight,
    hairline: AppColors.hairlineLight,
  );

  static const dark = AppCanvas(
    canvas: AppColors.canvasDark,
    panel: AppColors.panelDark,
    field: AppColors.fieldDark,
    brass: AppColors.brassDark,
    glow: AppColors.glowDark,
    hairline: AppColors.hairlineDark,
  );

  @override
  AppCanvas copyWith({
    Color? canvas,
    Color? panel,
    Color? field,
    Color? brass,
    Color? glow,
    Color? hairline,
  }) {
    return AppCanvas(
      canvas: canvas ?? this.canvas,
      panel: panel ?? this.panel,
      field: field ?? this.field,
      brass: brass ?? this.brass,
      glow: glow ?? this.glow,
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
      brass: Color.lerp(brass, other.brass, t)!,
      glow: Color.lerp(glow, other.glow, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
    );
  }
}

extension AppCanvasContext on BuildContext {
  AppCanvas get appCanvas {
    return Theme.of(this).extension<AppCanvas>() ?? AppCanvas.light;
  }
}
