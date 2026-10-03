import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';

/// Large numeric body mass index.
class BmiValueText extends StatelessWidget {
  const BmiValueText({super.key, required this.valueText, this.color});

  final String valueText;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'شاخص توده بدنی',
      value: valueText,
      child: AnimatedSwitcher(
        duration: AppMotion.durationOf(context, AppMotion.short),
        child: Text(
          valueText,
          key: ValueKey(valueText),
          textDirection: TextDirection.ltr,
          style: textTheme.displayLarge?.copyWith(height: 1, color: color),
        ),
      ),
    );
  }
}
