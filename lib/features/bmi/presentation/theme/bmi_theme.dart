import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/theme/app_theme.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_status_palette.dart';

/// BMI screen theme: the shared design system plus status colors.
abstract final class BmiTheme {
  static ThemeData get light => AppTheme.light([BmiStatusPalette.light]);

  static ThemeData get dark => AppTheme.dark([BmiStatusPalette.dark]);
}
