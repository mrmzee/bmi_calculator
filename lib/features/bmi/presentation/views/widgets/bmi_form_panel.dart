import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_history_entry.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_unit.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/latest_reading_card.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/weight_height_fields.dart';

/// Last reading, then the scale for a new measurement.
class BmiFormPanel extends StatelessWidget {
  const BmiFormPanel({
    super.key,
    required this.weightController,
    required this.heightController,
    required this.weightUnit,
    required this.heightUnit,
    required this.onWeightUnitChanged,
    required this.onHeightUnitChanged,
    this.latest,
    this.previous,
    this.goalWeightKg,
    this.onOpenLatest,
  });

  final TextEditingController weightController;
  final TextEditingController heightController;
  final WeightUnit weightUnit;
  final HeightUnit heightUnit;
  final ValueChanged<WeightUnit> onWeightUnitChanged;
  final ValueChanged<HeightUnit> onHeightUnitChanged;
  final BmiHistoryEntry? latest;
  final BmiHistoryEntry? previous;
  final double? goalWeightKg;
  final VoidCallback? onOpenLatest;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (latest != null && onOpenLatest != null) ...[
          LatestReadingCard(
            entry: latest!,
            previous: previous,
            goalWeightKg: goalWeightKg,
            onOpen: onOpenLatest!,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        WeightHeightFields(
          weightController: weightController,
          heightController: heightController,
          weightUnit: weightUnit,
          heightUnit: heightUnit,
          onWeightUnitChanged: onWeightUnitChanged,
          onHeightUnitChanged: onHeightUnitChanged,
        ),
      ],
    );
  }
}
