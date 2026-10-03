import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/healthy_weight_range.dart';

/// Derives the WHO normal-band weight range for a height in meters.
final class ComputeHealthyWeightRange {
  const ComputeHealthyWeightRange();

  HealthyWeightRange call(double heightMeters) {
    final squared = heightMeters * heightMeters;
    return HealthyWeightRange(
      minKg: Bmi.normalLowerBound * squared,
      maxKg: Bmi.normalUpperBound * squared,
    );
  }
}
