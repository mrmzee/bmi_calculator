import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_history_entry.dart';

/// Change since the previous saved reading, in BMI points.
String bmiDeltaLabel({
  required double current,
  required double previous,
}) {
  final delta = current - previous;
  if (delta.abs() < 0.05) {
    return 'بدون تغییر نسبت به سنجش قبلی';
  }
  final amount = delta.abs().toStringAsFixed(1);
  if (delta < 0) {
    return '$amount کمتر از سنجش قبلی';
  }
  return '$amount بیشتر از سنجش قبلی';
}

/// Distance between the current weight and a goal, in kilograms.
String goalDistanceLabel({
  required double goalKg,
  required double weightKg,
}) {
  final delta = weightKg - goalKg;
  final goalText = formatKilograms(goalKg);
  if (delta.abs() < 0.05) {
    return 'وزن با هدف $goalText کیلوگرم یکی است';
  }
  final amount = formatKilograms(delta.abs());
  if (delta > 0) {
    return '$amount کیلوگرم بالاتر از هدف $goalText';
  }
  return '$amount کیلوگرم پایین‌تر از هدف $goalText';
}

/// Weight and height of one saved reading, in Persian units.
String measurementLine(BmiHistoryEntry entry) {
  final kilograms = formatKilograms(entry.weightKg);
  final centimeters = (entry.heightMeters * 100).round();
  return '$kilograms کیلوگرم · $centimeters سانتی‌متر';
}

/// Kilograms with a trailing zero only when the tenth is not zero.
String formatKilograms(double kilograms) {
  if ((kilograms - kilograms.roundToDouble()).abs() < 0.05) {
    return kilograms.round().toString();
  }
  return kilograms.toStringAsFixed(1);
}
