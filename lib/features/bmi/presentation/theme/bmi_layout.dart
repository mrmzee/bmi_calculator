import 'package:mrmzee_bmi_calculator/design_system/tokens/app_spacing.dart';

/// Widths and the result dial size for the BMI screen.
abstract final class BmiLayout {
  static const double wide = 840;

  static const double short = 700;

  static const double compactMaxWidth = 520;

  static const double wideMaxWidth = 1080;

  /// Preferred diameter of the result dial.
  static const double dial = 16.5 * AppSpacing.spaceUnit;
}
