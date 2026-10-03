import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_category.dart';

/// Visual status of the BMI screen.
///
/// [empty] covers no reading and a calculated value of zero, which keeps the
/// resting background.
enum BmiStatus {
  empty,
  severeThinness,
  moderateThinness,
  mildThinness,
  normal,
  overweight,
  obeseClass1,
  obeseClass2,
  obeseClass3,
}

/// Broad band used by the spectrum bar.
enum BmiSpectrumBand {
  underweight,
  normal,
  overweight,
  obese,
}

/// Maps a domain [Bmi] to the screen [BmiStatus].
BmiStatus bmiStatusOf(Bmi? bmi) {
  if (bmi == null || bmi.value == 0) {
    return BmiStatus.empty;
  }
  return switch (bmi.category) {
    BmiCategory.severeThinness => BmiStatus.severeThinness,
    BmiCategory.moderateThinness => BmiStatus.moderateThinness,
    BmiCategory.mildThinness => BmiStatus.mildThinness,
    BmiCategory.normal => BmiStatus.normal,
    BmiCategory.overweight => BmiStatus.overweight,
    BmiCategory.obeseClass1 => BmiStatus.obeseClass1,
    BmiCategory.obeseClass2 => BmiStatus.obeseClass2,
    BmiCategory.obeseClass3 => BmiStatus.obeseClass3,
  };
}

extension BmiStatusSpectrum on BmiStatus {
  BmiSpectrumBand? get spectrumBand {
    return switch (this) {
      BmiStatus.empty => null,
      BmiStatus.severeThinness ||
      BmiStatus.moderateThinness ||
      BmiStatus.mildThinness =>
        BmiSpectrumBand.underweight,
      BmiStatus.normal => BmiSpectrumBand.normal,
      BmiStatus.overweight => BmiSpectrumBand.overweight,
      BmiStatus.obeseClass1 ||
      BmiStatus.obeseClass2 ||
      BmiStatus.obeseClass3 =>
        BmiSpectrumBand.obese,
    };
  }
}
