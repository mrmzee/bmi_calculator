import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';

/// Primary action that runs the BMI calculation.
class CalculateBmiButton extends StatelessWidget {
  const CalculateBmiButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final canvas = context.appCanvas;
    final highlight = Color.lerp(canvas.accent, colorScheme.onPrimary, 0.28)!;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.centerStart,
          end: AlignmentDirectional.centerEnd,
          colors: [canvas.accent, highlight],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.control),
        boxShadow: [
          BoxShadow(
            color: canvas.accent.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: FilledButton.icon(
        key: const Key('calculate-button'),
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_outward),
        label: const Text('محاسبه شاخص'),
        style: FilledButton.styleFrom(
          backgroundColor: canvas.accent.withValues(alpha: 0),
          shadowColor: canvas.accent.withValues(alpha: 0),
          elevation: 0,
          minimumSize: const Size.fromHeight(AppSpacing.control),
        ),
      ),
    );
  }
}
