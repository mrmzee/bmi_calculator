import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_unit.dart';

/// Compact pill control for weight or height units.
class WeightUnitSelector extends StatelessWidget {
  const WeightUnitSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final WeightUnit value;
  final ValueChanged<WeightUnit> onChanged;

  @override
  Widget build(BuildContext context) {
    return _UnitPill<WeightUnit>(
      options: const [
        _UnitOption(
            value: WeightUnit.kilogram, label: 'kg', tooltip: 'کیلوگرم'),
        _UnitOption(value: WeightUnit.pound, label: 'lb', tooltip: 'پوند'),
      ],
      selected: value,
      onChanged: onChanged,
    );
  }
}

class HeightUnitSelector extends StatelessWidget {
  const HeightUnitSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final HeightUnit value;
  final ValueChanged<HeightUnit> onChanged;

  @override
  Widget build(BuildContext context) {
    return _UnitPill<HeightUnit>(
      options: const [
        _UnitOption(
            value: HeightUnit.centimeter, label: 'cm', tooltip: 'سانتی‌متر'),
        _UnitOption(value: HeightUnit.meter, label: 'm', tooltip: 'متر'),
      ],
      selected: value,
      onChanged: onChanged,
    );
  }
}

class _UnitOption<T> {
  const _UnitOption({
    required this.value,
    required this.label,
    required this.tooltip,
  });

  final T value;
  final String label;
  final String tooltip;
}

class _UnitPill<T extends Object> extends StatelessWidget {
  const _UnitPill({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<_UnitOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final canvas = context.appCanvas;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: canvas.field,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(color: canvas.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final option in options)
              _UnitChoice(
                label: option.label,
                tooltip: option.tooltip,
                selected: option.value == selected,
                onPressed: () => onChanged(option.value),
              ),
          ],
        ),
      ),
    );
  }
}

class _UnitChoice extends StatelessWidget {
  const _UnitChoice({
    required this.label,
    required this.tooltip,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final String tooltip;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Tooltip(
      message: tooltip,
      child: Semantics(
        selected: selected,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor:
                selected ? colorScheme.surface : colorScheme.onSurface,
            backgroundColor: selected ? colorScheme.onSurface : null,
            minimumSize: const Size(
              AppSpacing.xxlg,
              AppSpacing.xlg + AppSpacing.xs,
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: const StadiumBorder(),
            textStyle: textTheme.labelLarge,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
