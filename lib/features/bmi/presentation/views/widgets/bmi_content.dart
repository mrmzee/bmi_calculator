import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_history_entry.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_unit.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_layout.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_state.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_form_panel.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_message_text.dart';

/// Measurement scale. The result opens on its own page.
class BmiContent extends StatelessWidget {
  const BmiContent({
    super.key,
    required this.state,
    required this.weightController,
    required this.heightController,
    required this.onWeightUnitChanged,
    required this.onHeightUnitChanged,
    this.latest,
    this.previous,
    this.goalWeightKg,
    this.onOpenLatest,
  });

  final BmiState state;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final ValueChanged<WeightUnit> onWeightUnitChanged;
  final ValueChanged<HeightUnit> onHeightUnitChanged;
  final BmiHistoryEntry? latest;
  final BmiHistoryEntry? previous;
  final double? goalWeightKg;
  final VoidCallback? onOpenLatest;

  @override
  Widget build(BuildContext context) {
    final showError = state.message.isNotEmpty && !state.hasResult;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: BmiLayout.compactMaxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showError) ...[
                BmiMessageText(message: state.message),
                const SizedBox(height: AppSpacing.lg),
              ],
              BmiFormPanel(
                weightController: weightController,
                heightController: heightController,
                weightUnit: state.weightUnit,
                heightUnit: state.heightUnit,
                onWeightUnitChanged: onWeightUnitChanged,
                onHeightUnitChanged: onHeightUnitChanged,
                latest: latest,
                previous: previous,
                goalWeightKg: goalWeightKg,
                onOpenLatest: onOpenLatest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
