import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_category.dart';

/// Body mass index. Classification is an enterprise rule and stays here.
final class Bmi {
  const Bmi({required this.value});

  /// Lower bound of moderate thinness (WHO).
  static const moderateThinnessLowerBound = 16.0;

  /// Lower bound of mild thinness (WHO).
  static const mildThinnessLowerBound = 17.0;

  /// Lower bound of the normal band (WHO).
  static const normalLowerBound = 18.5;

  /// Lower bound of overweight (WHO). Exactly 25 is overweight.
  static const overweightLowerBound = 25.0;

  /// Lower bound of obesity class I (WHO).
  static const obeseClass1LowerBound = 30.0;

  /// Lower bound of obesity class II (WHO).
  static const obeseClass2LowerBound = 35.0;

  /// Lower bound of obesity class III (WHO).
  static const obeseClass3LowerBound = 40.0;

  /// Inclusive upper edge of the healthy weight band for messaging.
  static const normalUpperBound = 24.9;

  /// Kilograms per square meter. Height is already in meters.
  final double value;

  BmiCategory get category {
    if (value >= obeseClass3LowerBound) {
      return BmiCategory.obeseClass3;
    }
    if (value >= obeseClass2LowerBound) {
      return BmiCategory.obeseClass2;
    }
    if (value >= obeseClass1LowerBound) {
      return BmiCategory.obeseClass1;
    }
    if (value >= overweightLowerBound) {
      return BmiCategory.overweight;
    }
    if (value >= normalLowerBound) {
      return BmiCategory.normal;
    }
    if (value >= mildThinnessLowerBound) {
      return BmiCategory.mildThinness;
    }
    if (value >= moderateThinnessLowerBound) {
      return BmiCategory.moderateThinness;
    }
    return BmiCategory.severeThinness;
  }
}
