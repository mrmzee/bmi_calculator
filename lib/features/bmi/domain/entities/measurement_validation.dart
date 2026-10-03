/// Why a measurement pair cannot produce a BMI.
enum MeasurementValidationError {
  incomplete,
  notNumeric,
  weightOutOfRange,
  heightOutOfRange,
}

/// Outcome of validating parsed weight and height in metric units.
sealed class MeasurementValidation {
  const MeasurementValidation();
}

final class MeasurementValidationSuccess extends MeasurementValidation {
  const MeasurementValidationSuccess({
    required this.weightKg,
    required this.heightMeters,
  });

  final double weightKg;
  final double heightMeters;
}

final class MeasurementValidationFailure extends MeasurementValidation {
  const MeasurementValidationFailure(this.error);

  final MeasurementValidationError error;
}
