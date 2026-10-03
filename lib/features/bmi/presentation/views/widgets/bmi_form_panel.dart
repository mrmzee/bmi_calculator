import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_unit.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/calculate_bmi_button.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/weight_height_fields.dart';

/// Measurement card: weight, height, units, and the calculate action.
class BmiFormPanel extends StatelessWidget {
  const BmiFormPanel({
    super.key,
    required this.weightController,
    required this.heightController,
    required this.weightUnit,
    required this.heightUnit,
    required this.onWeightUnitChanged,
    required this.onHeightUnitChanged,
    required this.onCalculate,
  });

  final TextEditingController weightController;
  final TextEditingController heightController;
  final WeightUnit weightUnit;
  final HeightUnit heightUnit;
  final ValueChanged<WeightUnit> onWeightUnitChanged;
  final ValueChanged<HeightUnit> onHeightUnitChanged;
  final VoidCallback onCalculate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('اندازه‌ها', style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'وزن و قد را وارد کنید تا شاخص روی صفحه بیاید.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            WeightHeightFields(
              weightController: weightController,
              heightController: heightController,
              weightUnit: weightUnit,
              heightUnit: heightUnit,
              onWeightUnitChanged: onWeightUnitChanged,
              onHeightUnitChanged: onHeightUnitChanged,
            ),
            const SizedBox(height: AppSpacing.lg),
            CalculateBmiButton(onPressed: onCalculate),
          ],
        ),
      ),
    );
  }
}
