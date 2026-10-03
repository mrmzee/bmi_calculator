import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_history_entry.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/use_cases/compute_healthy_weight_range.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/use_cases/interpret_bmi.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_category_message.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_state.dart';

/// Screen state for one saved calculation.
BmiState stateForHistoryEntry(BmiHistoryEntry entry) {
  final bmi = Bmi(value: entry.bmiValue);
  final interpretation = const InterpretBmi()(
    bmi: bmi,
    ageYears: entry.ageYears,
  );
  if (interpretation.isYouth) {
    return BmiState(
      bmi: bmi,
      isYouth: true,
      message: youthResultMessage,
      weightKg: entry.weightKg,
      heightMeters: entry.heightMeters,
    );
  }
  final range = const ComputeHealthyWeightRange()(entry.heightMeters);
  return BmiState(
    bmi: bmi,
    message: bmi.category.message,
    healthyWeightRange: range,
    healthyWeightMessage: healthyWeightRangeMessage(
      minKg: range.minKg,
      maxKg: range.maxKg,
      weightKg: entry.weightKg,
    ),
    weightKg: entry.weightKg,
    heightMeters: entry.heightMeters,
  );
}

/// Plain-text summary for the system share sheet.
String shareSummaryFor(
  BmiState state, {
  String? goalLine,
}) {
  final reading = state.bmi;
  if (reading == null) {
    return 'محاسبه‌گر شاخص توده بدنی';
  }
  final buffer = StringBuffer()
    ..writeln('شاخص توده بدنی: ${reading.value.toStringAsFixed(2)}')
    ..writeln(state.message);
  if (state.healthyWeightMessage.isNotEmpty) {
    buffer.writeln(state.healthyWeightMessage);
  }
  if (goalLine != null && goalLine.isNotEmpty) {
    buffer.writeln(goalLine);
  }
  buffer.writeln(medicalDisclaimerMessage);
  return buffer.toString().trim();
}
