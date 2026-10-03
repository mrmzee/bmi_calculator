import 'package:flutter_test/flutter_test.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_validation.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/use_cases/validate_measurements.dart';

void main() {
  group(ValidateMeasurements, () {
    const validate = ValidateMeasurements();

    test('returns incomplete when a field has no text', () {
      final result = validate(
        weightKg: null,
        heightMeters: 1.75,
        weightHadText: false,
        heightHadText: true,
      );

      expect(
        result,
        isA<MeasurementValidationFailure>().having(
          (failure) => failure.error,
          'error',
          MeasurementValidationError.incomplete,
        ),
      );
    });

    test('returns notNumeric when text cannot be parsed', () {
      final result = validate(
        weightKg: null,
        heightMeters: 1.75,
        weightHadText: true,
        heightHadText: true,
      );

      expect(
        result,
        isA<MeasurementValidationFailure>().having(
          (failure) => failure.error,
          'error',
          MeasurementValidationError.notNumeric,
        ),
      );
    });

    test('returns weightOutOfRange for unrealistic weight', () {
      final result = validate(
        weightKg: 1,
        heightMeters: 1.75,
        weightHadText: true,
        heightHadText: true,
      );

      expect(
        result,
        isA<MeasurementValidationFailure>().having(
          (failure) => failure.error,
          'error',
          MeasurementValidationError.weightOutOfRange,
        ),
      );
    });

    test('returns success for valid metric values', () {
      final result = validate(
        weightKg: 70,
        heightMeters: 1.75,
        weightHadText: true,
        heightHadText: true,
      );

      expect(
        result,
        isA<MeasurementValidationSuccess>()
            .having((success) => success.weightKg, 'weightKg', 70)
            .having((success) => success.heightMeters, 'heightMeters', 1.75),
      );
    });
  });
}
