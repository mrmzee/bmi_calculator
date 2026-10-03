import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_history_entry.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/healthy_weight_range.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_unit.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_status.dart';

/// Values the BMI screen renders.
final class BmiState {
  const BmiState({
    this.bmi,
    this.message = '',
    this.healthyWeightRange,
    this.healthyWeightMessage = '',
    this.weightKg,
    this.heightMeters,
    this.weightUnit = WeightUnit.kilogram,
    this.heightUnit = HeightUnit.centimeter,
    this.history = const [],
    this.isHistoryLoading = false,
  });

  final Bmi? bmi;
  final String message;
  final HealthyWeightRange? healthyWeightRange;
  final String healthyWeightMessage;
  final double? weightKg;
  final double? heightMeters;
  final WeightUnit weightUnit;
  final HeightUnit heightUnit;
  final List<BmiHistoryEntry> history;
  final bool isHistoryLoading;

  /// Formatted index, or `0.00` before the first successful calculation.
  String get valueText {
    final reading = bmi;
    if (reading == null) {
      return '0.00';
    }
    return reading.value.toStringAsFixed(2);
  }

  BmiStatus get status => bmiStatusOf(bmi);

  bool get hasResult => bmi != null && bmi!.value > 0;

  BmiState copyWith({
    Bmi? bmi,
    String? message,
    HealthyWeightRange? healthyWeightRange,
    String? healthyWeightMessage,
    double? weightKg,
    double? heightMeters,
    WeightUnit? weightUnit,
    HeightUnit? heightUnit,
    List<BmiHistoryEntry>? history,
    bool? isHistoryLoading,
  }) {
    return BmiState(
      bmi: bmi ?? this.bmi,
      message: message ?? this.message,
      healthyWeightRange: healthyWeightRange ?? this.healthyWeightRange,
      healthyWeightMessage: healthyWeightMessage ?? this.healthyWeightMessage,
      weightKg: weightKg ?? this.weightKg,
      heightMeters: heightMeters ?? this.heightMeters,
      weightUnit: weightUnit ?? this.weightUnit,
      heightUnit: heightUnit ?? this.heightUnit,
      history: history ?? this.history,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
    );
  }
}
