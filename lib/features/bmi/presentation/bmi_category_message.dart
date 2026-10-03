import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_category.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_validation.dart';

/// Shown when a required field is empty.
const incompleteInputMessage = 'لطفاً هر دو فیلد را پر کنید.';

/// Shown when text cannot be parsed as a number.
const notNumericInputMessage = 'لطفاً وزن و قد را به‌صورت عدد وارد کنید.';

/// Shown when weight is outside the accepted adult range.
const weightOutOfRangeMessage =
    'وزن باید بین ۲ تا ۵۰۰ کیلوگرم (یا معادل آن) باشد.';

/// Shown when height is outside the accepted adult range.
const heightOutOfRangeMessage = 'قد باید بین ۵۰ سانتی‌متر تا ۲٫۵ متر باشد.';

/// Shown for a calculation saved before age 18.
const youthResultMessage = 'این شاخص برای کودک و نوجوان است. '
    'دسته‌بندی بزرگسال برای این سن به کار نمی‌رود.';

/// Short history label when adult bands are withheld.
const youthResultLabel = 'کودک و نوجوان';

/// Medical disclaimer under the result.
const medicalDisclaimerMessage =
    'شاخص توده بدنی جایگزین تشخیص پزشکی نیست و برای ورزشکاران، '
    'بارداری، کودکان و سالمندان تفسیر متفاوتی دارد.';

/// Persian sentence for a validation failure.
String messageForValidationError(MeasurementValidationError error) {
  return switch (error) {
    MeasurementValidationError.incomplete => incompleteInputMessage,
    MeasurementValidationError.notNumeric => notNumericInputMessage,
    MeasurementValidationError.weightOutOfRange => weightOutOfRangeMessage,
    MeasurementValidationError.heightOutOfRange => heightOutOfRangeMessage,
  };
}

/// Persian sentence for a [BmiCategory].
extension BmiCategoryMessage on BmiCategory {
  String get message {
    return switch (this) {
      BmiCategory.severeThinness =>
        'شاخص توده بدنی شما در محدودهٔ کمبود وزن شدید قرار می‌گیرد.',
      BmiCategory.moderateThinness =>
        'شاخص توده بدنی شما در محدودهٔ کمبود وزن متوسط قرار می‌گیرد.',
      BmiCategory.mildThinness =>
        'شاخص توده بدنی شما در محدودهٔ کمبود وزن خفیف قرار می‌گیرد.',
      BmiCategory.normal =>
        'شاخص توده بدنی شما در محدودهٔ وزن سالم قرار می‌گیرد.',
      BmiCategory.overweight =>
        'شاخص توده بدنی شما در محدودهٔ اضافه‌وزن قرار می‌گیرد.',
      BmiCategory.obeseClass1 =>
        'شاخص توده بدنی شما در محدودهٔ چاقی درجهٔ یک قرار می‌گیرد.',
      BmiCategory.obeseClass2 =>
        'شاخص توده بدنی شما در محدودهٔ چاقی درجهٔ دو قرار می‌گیرد.',
      BmiCategory.obeseClass3 =>
        'شاخص توده بدنی شما در محدودهٔ چاقی درجهٔ سه قرار می‌گیرد.',
    };
  }

  String get shortLabel {
    return switch (this) {
      BmiCategory.severeThinness => 'کمبود وزن شدید',
      BmiCategory.moderateThinness => 'کمبود وزن متوسط',
      BmiCategory.mildThinness => 'کمبود وزن خفیف',
      BmiCategory.normal => 'وزن سالم',
      BmiCategory.overweight => 'اضافه‌وزن',
      BmiCategory.obeseClass1 => 'چاقی درجه ۱',
      BmiCategory.obeseClass2 => 'چاقی درجه ۲',
      BmiCategory.obeseClass3 => 'چاقی درجه ۳',
    };
  }
}

/// Builds the healthy-weight summary for the current height.
String healthyWeightRangeMessage({
  required double minKg,
  required double maxKg,
  required double weightKg,
}) {
  final minText = _formatKg(minKg);
  final maxText = _formatKg(maxKg);
  if (weightKg < minKg) {
    final delta = _formatKg(minKg - weightKg);
    return 'برای قد شما، وزن سالم حدوداً بین $minText تا $maxText '
        'کیلوگرم است. حدود $delta کیلوگرم تا رسیدن به این بازه فاصله دارید.';
  }
  if (weightKg > maxKg) {
    final delta = _formatKg(weightKg - maxKg);
    return 'برای قد شما، وزن سالم حدوداً بین $minText تا $maxText '
        'کیلوگرم است. حدود $delta کیلوگرم بالاتر از این بازه هستید.';
  }
  return 'برای قد شما، وزن سالم حدوداً بین $minText تا $maxText '
      'کیلوگرم است و وزن فعلی‌تان در این بازه قرار دارد.';
}

String _formatKg(double value) {
  if ((value - value.roundToDouble()).abs() < 0.05) {
    return value.round().toString();
  }
  return value.toStringAsFixed(1);
}
