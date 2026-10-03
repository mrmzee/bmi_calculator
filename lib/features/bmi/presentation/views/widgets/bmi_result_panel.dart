import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_status.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_layout.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_status_palette.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_state.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_dial.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_message_text.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_value_text.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/healthy_weight_card.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/medical_disclaimer.dart';

/// Visual ceiling of the scale. Values above this sit at the end.
const _scaleMax = 40.0;

/// Dial, category, spectrum, and the healthy-weight note.
class BmiResultPanel extends StatelessWidget {
  const BmiResultPanel({super.key, required this.state});

  final BmiState state;

  @override
  Widget build(BuildContext context) {
    final progress = ((state.bmi?.value ?? 0) / _scaleMax).clamp(0.0, 1.0);
    final palette = context.bmiStatusPalette;
    final accent = palette.of(state.status);
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final windowHeight = MediaQuery.sizeOf(context).height;
        var diameter = math.min(BmiLayout.dial, constraints.maxWidth * 0.86);
        if (windowHeight < BmiLayout.short) {
          diameter = math.min(diameter, 210);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: BmiDial(
                diameter: diameter,
                accent: accent,
                progress: state.hasResult ? progress : 0,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: FittedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'BMI',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: context.appCanvas.brass,
                                  ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        BmiValueText(
                          valueText: state.valueText,
                          color: colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            BmiMessageText(message: state.message),
            const SizedBox(height: AppSpacing.lg),
            _Spectrum(status: state.status),
            if (state.healthyWeightMessage.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              HealthyWeightCard(message: state.healthyWeightMessage),
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

class _Spectrum extends StatelessWidget {
  const _Spectrum({required this.status});

  final BmiStatus status;

  @override
  Widget build(BuildContext context) {
    final active = status.spectrumBand;
    final palette = context.bmiStatusPalette;

    return Semantics(
      label: 'طیف دسته‌بندی شاخص توده بدنی',
      child: Row(
        children: [
          for (final band in BmiSpectrumBand.values) ...[
            if (band.index > 0) const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _SpectrumBand(
                label: band.posterLabel,
                color: palette.ofSpectrumBand(band),
                active: band == active,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SpectrumBand extends StatelessWidget {
  const _SpectrumBand({
    required this.label,
    required this.color,
    required this.active,
  });

  final String label;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final canvas = context.appCanvas;

    return Column(
      children: [
        AnimatedContainer(
          duration: AppMotion.durationOf(context, AppMotion.short),
          curve: AppMotion.decelerate,
          height: active ? AppSpacing.sm : AppSpacing.xs,
          decoration: BoxDecoration(
            color: active ? color : canvas.hairline,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            color:
                active ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

extension on BmiSpectrumBand {
  String get posterLabel {
    return switch (this) {
      BmiSpectrumBand.underweight => 'کمبود',
      BmiSpectrumBand.normal => 'سالم',
      BmiSpectrumBand.overweight => 'اضافه',
      BmiSpectrumBand.obese => 'چاقی',
    };
  }
}
