/// Healthy adult weight band for a height, derived from WHO normal BMI.
final class HealthyWeightRange {
  const HealthyWeightRange({
    required this.minKg,
    required this.maxKg,
  });

  final double minKg;
  final double maxKg;

  /// Kilograms above [maxKg], or below [minKg] when under the band.
  ///
  /// Zero when [weightKg] is already inside the healthy band.
  double deltaKg(double weightKg) {
    if (weightKg < minKg) {
      return minKg - weightKg;
    }
    if (weightKg > maxKg) {
      return weightKg - maxKg;
    }
    return 0;
  }

  bool contains(double weightKg) {
    return weightKg >= minKg && weightKg <= maxKg;
  }
}
