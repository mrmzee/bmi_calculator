import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_status.dart';

/// Status accents that stay readable on the active light or dark scheme.
abstract final class BmiStatusColors {
  static const empty = Color(0xFF3F3A34);
  static const severeThinness = Color(0xFF1D4ED8);
  static const moderateThinness = Color(0xFF2563EB);
  static const mildThinness = Color(0xFF0369A1);
  static const normal = Color(0xFF047857);
  static const overweight = Color(0xFFC2410C);
  static const obeseClass1 = Color(0xFFB91C1C);
  static const obeseClass2 = Color(0xFF9F1239);
  static const obeseClass3 = Color(0xFF701A75);

  static const emptyDark = Color(0xFF94A3B8);
  static const severeThinnessDark = Color(0xFF93C5FD);
  static const moderateThinnessDark = Color(0xFF60A5FA);
  static const mildThinnessDark = Color(0xFF38BDF8);
  static const normalDark = Color(0xFF34D399);
  static const overweightDark = Color(0xFFFBBF24);
  static const obeseClass1Dark = Color(0xFFF87171);
  static const obeseClass2Dark = Color(0xFFFB7185);
  static const obeseClass3Dark = Color(0xFFE879F9);

  static const onStatus = Color(0xFFFFFFFF);
  static const onStatusDark = Color(0xFF042F2E);
}

/// BMI category colors exposed through the active theme.
final class BmiStatusPalette extends ThemeExtension<BmiStatusPalette> {
  const BmiStatusPalette({
    required this.empty,
    required this.severeThinness,
    required this.moderateThinness,
    required this.mildThinness,
    required this.normal,
    required this.overweight,
    required this.obeseClass1,
    required this.obeseClass2,
    required this.obeseClass3,
    required this.foreground,
  });

  final Color empty;
  final Color severeThinness;
  final Color moderateThinness;
  final Color mildThinness;
  final Color normal;
  final Color overweight;
  final Color obeseClass1;
  final Color obeseClass2;
  final Color obeseClass3;
  final Color foreground;

  static const light = BmiStatusPalette(
    empty: BmiStatusColors.empty,
    severeThinness: BmiStatusColors.severeThinness,
    moderateThinness: BmiStatusColors.moderateThinness,
    mildThinness: BmiStatusColors.mildThinness,
    normal: BmiStatusColors.normal,
    overweight: BmiStatusColors.overweight,
    obeseClass1: BmiStatusColors.obeseClass1,
    obeseClass2: BmiStatusColors.obeseClass2,
    obeseClass3: BmiStatusColors.obeseClass3,
    foreground: BmiStatusColors.onStatus,
  );

  static const dark = BmiStatusPalette(
    empty: BmiStatusColors.emptyDark,
    severeThinness: BmiStatusColors.severeThinnessDark,
    moderateThinness: BmiStatusColors.moderateThinnessDark,
    mildThinness: BmiStatusColors.mildThinnessDark,
    normal: BmiStatusColors.normalDark,
    overweight: BmiStatusColors.overweightDark,
    obeseClass1: BmiStatusColors.obeseClass1Dark,
    obeseClass2: BmiStatusColors.obeseClass2Dark,
    obeseClass3: BmiStatusColors.obeseClass3Dark,
    foreground: BmiStatusColors.onStatusDark,
  );

  Color of(BmiStatus status) {
    return switch (status) {
      BmiStatus.empty => empty,
      BmiStatus.severeThinness => severeThinness,
      BmiStatus.moderateThinness => moderateThinness,
      BmiStatus.mildThinness => mildThinness,
      BmiStatus.normal => normal,
      BmiStatus.overweight => overweight,
      BmiStatus.obeseClass1 => obeseClass1,
      BmiStatus.obeseClass2 => obeseClass2,
      BmiStatus.obeseClass3 => obeseClass3,
    };
  }

  Color ofSpectrumBand(BmiSpectrumBand band) {
    return switch (band) {
      BmiSpectrumBand.underweight => mildThinness,
      BmiSpectrumBand.normal => normal,
      BmiSpectrumBand.overweight => overweight,
      BmiSpectrumBand.obese => obeseClass2,
    };
  }

  @override
  BmiStatusPalette copyWith({
    Color? empty,
    Color? severeThinness,
    Color? moderateThinness,
    Color? mildThinness,
    Color? normal,
    Color? overweight,
    Color? obeseClass1,
    Color? obeseClass2,
    Color? obeseClass3,
    Color? foreground,
  }) {
    return BmiStatusPalette(
      empty: empty ?? this.empty,
      severeThinness: severeThinness ?? this.severeThinness,
      moderateThinness: moderateThinness ?? this.moderateThinness,
      mildThinness: mildThinness ?? this.mildThinness,
      normal: normal ?? this.normal,
      overweight: overweight ?? this.overweight,
      obeseClass1: obeseClass1 ?? this.obeseClass1,
      obeseClass2: obeseClass2 ?? this.obeseClass2,
      obeseClass3: obeseClass3 ?? this.obeseClass3,
      foreground: foreground ?? this.foreground,
    );
  }

  @override
  BmiStatusPalette lerp(BmiStatusPalette? other, double t) {
    if (other is! BmiStatusPalette) {
      return this;
    }
    return BmiStatusPalette(
      empty: Color.lerp(empty, other.empty, t)!,
      severeThinness: Color.lerp(severeThinness, other.severeThinness, t)!,
      moderateThinness:
          Color.lerp(moderateThinness, other.moderateThinness, t)!,
      mildThinness: Color.lerp(mildThinness, other.mildThinness, t)!,
      normal: Color.lerp(normal, other.normal, t)!,
      overweight: Color.lerp(overweight, other.overweight, t)!,
      obeseClass1: Color.lerp(obeseClass1, other.obeseClass1, t)!,
      obeseClass2: Color.lerp(obeseClass2, other.obeseClass2, t)!,
      obeseClass3: Color.lerp(obeseClass3, other.obeseClass3, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
    );
  }
}

extension BmiStatusPaletteContext on BuildContext {
  BmiStatusPalette get bmiStatusPalette {
    return Theme.of(this).extension<BmiStatusPalette>() ??
        BmiStatusPalette.light;
  }
}
