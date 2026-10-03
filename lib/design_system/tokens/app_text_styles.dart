import 'package:flutter/material.dart';

/// Typography scale. Colors come from the active [ColorScheme].
abstract final class AppTextStyles {
  static const fontFamily = 'Vazirmatn';

  static TextTheme textTheme(ColorScheme scheme) {
    final base = TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: scheme.onSurface,
    );

    return TextTheme(
      displayLarge: base.copyWith(
        fontSize: 56,
        height: 1,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
      ),
      headlineSmall: base.copyWith(
        fontSize: 32,
        height: 1.15,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: base.copyWith(
        fontSize: 22,
        height: 1.3,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.copyWith(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.copyWith(fontSize: 16, height: 1.5),
      bodyMedium: base.copyWith(
        fontSize: 14,
        height: 1.45,
        color: scheme.onSurfaceVariant,
      ),
      bodySmall: base.copyWith(
        fontSize: 12,
        height: 1.4,
        color: scheme.onSurfaceVariant,
      ),
      labelLarge: base.copyWith(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: base.copyWith(
        fontSize: 11,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.2,
      ),
    );
  }
}
