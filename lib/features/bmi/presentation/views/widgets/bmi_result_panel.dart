import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_category_message.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_reading_copy.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_status.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_layout.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_status_palette.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_state.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_dial.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_message_text.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_value_text.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/healthy_weight_card.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/medical_disclaimer.dart';

/// Lowest BMI drawn at the start of the gauge.
const _scaleMin = 15.0;

/// Highest BMI drawn at the end of the gauge.
const _scaleMax = 40.0;

/// Gauge, category, spectrum, goal, and the healthy-weight note.
class BmiResultPanel extends StatelessWidget {
  const BmiResultPanel({
    super.key,
    required this.state,
    this.goalWeightKg,
  });

  final BmiState state;
  final double? goalWeightKg;

  @override
  Widget build(BuildContext context) {
    final reading = state.bmi?.value ?? _scaleMin;
    final progress =
        ((reading - _scaleMin) / (_scaleMax - _scaleMin)).clamp(0.0, 1.0);
    final palette = context.bmiStatusPalette;
    final accent = palette.of(state.status);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final categoryLabel =
        state.isYouth ? youthResultLabel : state.bmi?.category.shortLabel ?? '';
    final weight = state.weightKg;
    final goal = goalWeightKg;

    return LayoutBuilder(
      builder: (context, constraints) {
        final windowHeight = MediaQuery.sizeOf(context).height;
        var diameter = math.min(BmiLayout.dial, constraints.maxWidth * 0.78);
        if (windowHeight < BmiLayout.short) {
          diameter = math.min(diameter, 220);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accent.withValues(alpha: state.hasResult ? 0.28 : 0.1),
                      accent.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: BmiDial(
                    diameter: diameter,
                    accent: accent,
                    progress: state.hasResult ? progress : 0,
                    showMarkers: !state.isYouth,
                    child: FittedBox(
                      child: BmiValueText(
                        valueText: state.valueText,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  child: Text(
                    categoryLabel,
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge?.copyWith(color: accent),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            BmiMessageText(message: state.message),
            if (!state.isYouth) ...[
              const SizedBox(height: AppSpacing.lg),
              _Spectrum(status: state.status),
            ],
            if (state.healthyWeightMessage.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              HealthyWeightCard(message: state.healthyWeightMessage),
            ],
            if (goal != null && weight != null) ...[
              const SizedBox(height: AppSpacing.md),
              _NoteCard(
                icon: Icons.flag_outlined,
                title: 'هدف وزن',
                message: goalDistanceLabel(goalKg: goal, weightKg: weight),
              ),
            ],
            if (state.hasResult) ...[
              const SizedBox(height: AppSpacing.md),
              const MedicalDisclaimer(),
            ],
          ],
        );
      },
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final canvas = context.appCanvas;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    message,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
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

class _Spectrum extends StatelessWidget {
  const _Spectrum({required this.status});

  final BmiStatus status;

  @override
  Widget build(BuildContext context) {
    final active = status.spectrumBand;
    final palette = context.bmiStatusPalette;
    final label = switch (active) {
      BmiSpectrumBand.underweight => 'کمبود وزن',
      BmiSpectrumBand.normal => 'وزن سالم',
      BmiSpectrumBand.overweight => 'اضافه‌وزن',
      BmiSpectrumBand.obese => 'چاقی',
      null => '',
    };

    return Semantics(
      label: 'طیف دسته‌بندی شاخص توده بدنی. دسته فعلی: $label',
      child: Column(
        children: [
          Row(
            children: [
              for (final band in BmiSpectrumBand.values) ...[
                if (band.index > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _SpectrumBand(
                    color: palette.ofSpectrumBand(band),
                    active: band == active,
                    label: switch (band) {
                      BmiSpectrumBand.underweight => 'کم',
                      BmiSpectrumBand.normal => 'سالم',
                      BmiSpectrumBand.overweight => 'اضافه',
                      BmiSpectrumBand.obese => 'چاقی',
                    },
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SpectrumBand extends StatelessWidget {
  const _SpectrumBand({
    required this.color,
    required this.active,
    required this.label,
  });

  final Color color;
  final bool active;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        AnimatedContainer(
          duration: AppMotion.durationOf(context, AppMotion.short),
          curve: AppMotion.decelerate,
          height: active ? AppSpacing.md : AppSpacing.sm,
          decoration: BoxDecoration(
            color: active ? color : color.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.35),
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelSmall?.copyWith(
            color: active ? color : colorScheme.onSurfaceVariant,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
