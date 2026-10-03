/// Spacing scale based on a 16-pixel unit.
abstract final class AppSpacing {
  static const double spaceUnit = 16;

  /// 4px
  static const double xxs = 0.25 * spaceUnit;

  /// 6px
  static const double xs = 0.375 * spaceUnit;

  /// 8px
  static const double sm = 0.5 * spaceUnit;

  /// 12px
  static const double md = 0.75 * spaceUnit;

  /// 16px
  static const double lg = spaceUnit;

  /// 24px
  static const double xlg = 1.5 * spaceUnit;

  /// 32px
  static const double xxlg = 2 * spaceUnit;

  static const double radius = lg;

  static const double radiusLarge = 1.75 * spaceUnit;

  /// Minimum height of the primary action.
  static const double control = 3.5 * spaceUnit;
}
