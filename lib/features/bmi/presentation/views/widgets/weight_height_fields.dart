import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_unit.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/unit_selector.dart';

/// Weight and height, each on its own surface.
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
        _ScaleField(
          fieldKey: const Key('weight-field'),
          controller: weightController,
          label: 'وزن',
          unit: WeightUnitSelector(
            value: weightUnit,
            onChanged: onWeightUnitChanged,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _ScaleField(
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

class _ScaleField extends StatefulWidget {
  const _ScaleField({
    required this.fieldKey,
    required this.controller,
    required this.label,
    this.unit,
    this.textInputAction = TextInputAction.next,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String label;
  final Widget? unit;
  final TextInputAction textInputAction;

  @override
  State<_ScaleField> createState() => _ScaleFieldState();
}

class _ScaleFieldState extends State<_ScaleField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocus)
      ..dispose();
    super.dispose();
  }

  void _onFocus() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final canvas = context.appCanvas;
    final valueStyle = textTheme.headlineMedium;
    final focused = _focus.hasFocus;
    final icon = widget.label == 'وزن'
        ? Icons.monitor_weight_outlined
        : Icons.straighten;

    return AnimatedContainer(
      duration: AppMotion.durationOf(context, AppMotion.short),
      curve: AppMotion.decelerate,
      decoration: BoxDecoration(
        color: canvas.panel,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(
          color: focused ? canvas.accent : canvas.hairline,
          width: focused ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: canvas.accent.withValues(alpha: focused ? 0.18 : 0.08),
            blurRadius: focused ? 24 : 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: canvas.accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(
                    dimension: AppSpacing.xxlg,
                    child: Center(
                      child: Icon(icon, color: canvas.accent, size: 18),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(widget.label, style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            DecoratedBox(
              decoration: BoxDecoration(
                color: canvas.field,
                borderRadius: BorderRadius.circular(AppSpacing.radius),
              ),
              child: TextField(
                key: widget.fieldKey,
                controller: widget.controller,
                focusNode: _focus,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: widget.textInputAction,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                style: valueStyle,
                decoration: InputDecoration(
                  hintText: '—',
                  hintStyle: valueStyle?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            if (widget.unit != null) ...[
              const SizedBox(height: AppSpacing.md),
              widget.unit!,
            ],
          ],
        ),
      ),
    );
  }
}
