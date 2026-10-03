import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_age_band.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_category.dart';

/// How a BMI number should be explained for a person's age.
final class BmiInterpretation {
  const BmiInterpretation.adult(this.category) : isYouth = false;

  const BmiInterpretation.youth()
      : isYouth = true,
        category = null;

  final bool isYouth;

  /// WHO band. Null for youth, where adult bands are not shown.
  final BmiCategory? category;
}

/// Chooses adult WHO bands or youth copy from the age at calculation time.
final class InterpretBmi {
  const InterpretBmi();

  BmiInterpretation call({required Bmi bmi, required int? ageYears}) {
    if (BmiAgeBand.isYouth(ageYears)) {
      return const BmiInterpretation.youth();
    }
    return BmiInterpretation.adult(bmi.category);
  }
}
