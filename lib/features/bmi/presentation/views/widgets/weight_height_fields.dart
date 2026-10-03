import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_unit.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/unit_selector.dart';

/// Weight and height inputs, each with its unit control on the same row.
class WeightHeightFields extends StatelessWidget {
  const WeightHeightFields({
    super.key,
    required this.weightController,
    required this.heightController,
    required this.weightUnit,
    required this.heightUnit,
    required this.onWeightUnitChanged,
    required this.onHeightUnitChanged,
  });

  final TextEditingController weightController;
  final TextEditingController heightController;
  final WeightUnit weightUnit;
  final HeightUnit heightUnit;
  final ValueChanged<WeightUnit> onWeightUnitChanged;
  final ValueChanged<HeightUnit> onHeightUnitChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MeasurementField(
          fieldKey: const Key('weight-field'),
          controller: weightController,
          label: 'وزن',
          unit: WeightUnitSelector(
            value: weightUnit,
            onChanged: onWeightUnitChanged,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _MeasurementField(
          fieldKey: const Key('height-field'),
          controller: heightController,
          label: 'قد',
          unit: HeightUnitSelector(
            value: heightUnit,
            onChanged: onHeightUnitChanged,
          ),
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}

class _MeasurementField extends StatelessWidget {
  const _MeasurementField({
    required this.fieldKey,
    required this.controller,
    required this.label,
    required this.unit,
    this.textInputAction = TextInputAction.next,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String label;
  final Widget unit;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final valueStyle = textTheme.titleLarge?.copyWith(
      height: 1,
      fontWeight: FontWeight.w600,
    );
    final fieldRadius = BorderRadius.circular(AppSpacing.radius);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            unit,
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          key: fieldKey,
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: textInputAction,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          style: valueStyle,
          strutStyle: StrutStyle(
            fontFamily: valueStyle?.fontFamily,
            fontSize: valueStyle?.fontSize,
            fontWeight: valueStyle?.fontWeight,
            height: 1,
            leadingDistribution: TextLeadingDistribution.even,
            forceStrutHeight: true,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: '0',
            hintStyle: valueStyle?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.28),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: fieldRadius,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: fieldRadius,
              borderSide: BorderSide(color: context.appCanvas.hairline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: fieldRadius,
              borderSide: BorderSide(
                color: context.appCanvas.brass,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
