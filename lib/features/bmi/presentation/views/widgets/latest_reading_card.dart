import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_history_entry.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_category_message.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_reading_copy.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_status.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_status_palette.dart';

/// Compact recall of the newest saved reading for the active person.
class LatestReadingCard extends StatelessWidget {
  const LatestReadingCard({
    super.key,
    required this.entry,
    required this.onOpen,
    this.previous,
    this.goalWeightKg,
  });

  final BmiHistoryEntry entry;
  final BmiHistoryEntry? previous;
  final double? goalWeightKg;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final status = entry.isYouth
        ? BmiStatus.youth
        : bmiStatusOf(Bmi(value: entry.bmiValue));
    final accent = context.bmiStatusPalette.of(status);
    final label = entry.isYouth ? youthResultLabel : entry.category.shortLabel;
    final delta = previous == null
        ? null
        : bmiDeltaLabel(current: entry.bmiValue, previous: previous!.bmiValue);
    final goal = goalWeightKg == null
        ? null
        : goalDistanceLabel(goalKg: goalWeightKg!, weightKg: entry.weightKg);

    return Card(
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLarge,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        child: Text(
                          'آخرین سنجش',
                          style: textTheme.labelMedium?.copyWith(color: accent),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(label, style: textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${formatJalaliDate(entry.recordedAt)} · '
                      '${measurementLine(entry)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (delta != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        delta,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (goal != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(goal, style: textTheme.bodyMedium),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Text(
                    entry.bmiValue.toStringAsFixed(2),
                    textDirection: TextDirection.ltr,
                    style: textTheme.headlineSmall?.copyWith(color: accent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
