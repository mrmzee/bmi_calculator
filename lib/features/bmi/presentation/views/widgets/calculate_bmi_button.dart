import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';

/// Primary action that runs the BMI calculation.
class CalculateBmiButton extends StatelessWidget {
  const CalculateBmiButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      key: const Key('calculate-button'),
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_outward),
      label: const Text('محاسبه شاخص'),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSpacing.control),
      ),
    );
  }
}
