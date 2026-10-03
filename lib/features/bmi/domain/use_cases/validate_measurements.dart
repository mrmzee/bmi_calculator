import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_validation.dart';

/// Guards BMI inputs before calculation.
///
/// Accepts already-parsed metric values. Null means the field text was empty
/// or not a number; [hadText] distinguishes those two cases.
final class ValidateMeasurements {
  const ValidateMeasurements();

  static const minWeightKg = 2.0;
  static const maxWeightKg = 500.0;
  static const minHeightMeters = 0.5;
  static const maxHeightMeters = 2.5;

  MeasurementValidation call({
    required double? weightKg,
    required double? heightMeters,
    required bool weightHadText,
    required bool heightHadText,
  }) {
    if (!weightHadText || !heightHadText) {
      return const MeasurementValidationFailure(
        MeasurementValidationError.incomplete,
      );
    }
    if (weightKg == null || heightMeters == null) {
      return const MeasurementValidationFailure(
        MeasurementValidationError.notNumeric,
      );
    }
    if (weightKg < minWeightKg || weightKg > maxWeightKg) {
      return const MeasurementValidationFailure(
        MeasurementValidationError.weightOutOfRange,
      );
    }
    if (heightMeters < minHeightMeters || heightMeters > maxHeightMeters) {
      return const MeasurementValidationFailure(
        MeasurementValidationError.heightOutOfRange,
      );
    }
    return MeasurementValidationSuccess(
      weightKg: weightKg,
      heightMeters: heightMeters,
    );
  }
}
