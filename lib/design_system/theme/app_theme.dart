import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/theme/app_canvas.dart';
import 'package:mrmzee_bmi_calculator/design_system/tokens/app_colors.dart';
import 'package:mrmzee_bmi_calculator/design_system/tokens/app_spacing.dart';
import 'package:mrmzee_bmi_calculator/design_system/tokens/app_text_styles.dart';

/// Light and dark Material 3 themes.
///
/// Feature-specific [ThemeExtension]s are passed in so this layer stays free
/// of screen concepts such as BMI status colors.
abstract final class AppTheme {
  static ThemeData light([
    List<ThemeExtension<dynamic>> extensions = const [],
  ]) {
    return _theme(Brightness.light, AppCanvas.light, extensions);
  }

  static ThemeData dark([
    List<ThemeExtension<dynamic>> extensions = const [],
  ]) {
    return _theme(Brightness.dark, AppCanvas.dark, extensions);
  }

  static ThemeData _theme(
    Brightness brightness,
    AppCanvas canvas,
    List<ThemeExtension<dynamic>> extensions,
  ) {
    final isLight = brightness == Brightness.light;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
    ).copyWith(
      surface: canvas.canvas,
      primary: isLight ? AppColors.seed : canvas.brass,
      onPrimary: isLight ? canvas.panel : AppColors.onBrass,
    );
    final textTheme = AppTextStyles.textTheme(colorScheme);
    final radius = BorderRadius.circular(AppSpacing.radiusLarge);
    final panelShape = RoundedRectangleBorder(
      borderRadius: radius,
      side: BorderSide(color: canvas.hairline),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: AppTextStyles.fontFamily,
      scaffoldBackgroundColor: canvas.canvas,
      extensions: [canvas, ...extensions],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: canvas.canvas,
        surfaceTintColor: canvas.canvas,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          disabledForegroundColor:
              colorScheme.onSurface.withValues(alpha: 0.28),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: canvas.panel,
        clipBehavior: Clip.antiAlias,
        shape: panelShape,
      ),
      dividerTheme: DividerThemeData(
        color: canvas.hairline,
        space: AppSpacing.lg,
        thickness: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: canvas.panel,
        shape: panelShape,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.onSurface,
          foregroundColor: colorScheme.surface,
          minimumSize: const Size(AppSpacing.control, AppSpacing.control),
          textStyle: textTheme.titleMedium,
          shape: const StadiumBorder(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: canvas.field,
        hintStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.28),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: canvas.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: canvas.brass, width: 1.5),
        ),
      ),
    );
  }
}
