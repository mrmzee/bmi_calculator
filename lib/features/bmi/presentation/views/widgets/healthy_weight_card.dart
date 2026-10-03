import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';

/// Healthy-weight copy beside the dial.
class HealthyWeightCard extends StatelessWidget {
  const HealthyWeightCard({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final canvas = context.appCanvas;

    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: canvas.accent.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(
                dimension: AppSpacing.xxlg,
                child: Center(
                  child: Icon(
                    Icons.favorite_outline,
                    size: 18,
                    color: canvas.accent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'بازه وزن سالم',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    message,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
