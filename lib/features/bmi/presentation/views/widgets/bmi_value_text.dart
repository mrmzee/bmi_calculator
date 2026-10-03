import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';

/// Large numeric body mass index that counts up to the reading.
class BmiValueText extends StatelessWidget {
  const BmiValueText({super.key, required this.valueText, this.color});

  final String valueText;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final parsed = double.tryParse(valueText);
    final style = Theme.of(context).textTheme.displayLarge?.copyWith(
          height: 1,
          color: color,
        );

    return Semantics(
      label: 'شاخص توده بدنی',
      value: valueText,
      child: parsed == null
          ? Text(
              valueText,
              textDirection: TextDirection.ltr,
              style: style,
            )
          : TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: parsed),
              duration: AppMotion.durationOf(context, AppMotion.long),
              curve: AppMotion.decelerate,
              builder: (context, value, _) {
                return Text(
                  value.toStringAsFixed(2),
                  textDirection: TextDirection.ltr,
                  style: style,
                );
              },
            ),
    );
  }
}
