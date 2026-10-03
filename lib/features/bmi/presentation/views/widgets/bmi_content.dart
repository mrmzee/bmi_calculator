import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_unit.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_layout.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_state.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_form_panel.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_history_section.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_result_panel.dart';

/// Scrollable BMI screen: dial, measurements, then history.
class BmiContent extends StatelessWidget {
  const BmiContent({
    super.key,
    required this.state,
    required this.weightController,
    required this.heightController,
    required this.onWeightUnitChanged,
    required this.onHeightUnitChanged,
    required this.onCalculate,
    required this.onClearHistory,
  });

  final BmiState state;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final ValueChanged<WeightUnit> onWeightUnitChanged;
  final ValueChanged<HeightUnit> onHeightUnitChanged;
  final VoidCallback onCalculate;
  final VoidCallback onClearHistory;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= BmiLayout.wide;
        final form = BmiFormPanel(
          weightController: weightController,
          heightController: heightController,
          weightUnit: state.weightUnit,
          heightUnit: state.heightUnit,
          onWeightUnitChanged: onWeightUnitChanged,
          onHeightUnitChanged: onHeightUnitChanged,
          onCalculate: onCalculate,
        );
        final result = BmiResultPanel(state: state);
        final history = state.history.isEmpty
            ? null
            : BmiHistorySection(
                entries: state.history,
                onClear: onClearHistory,
              );

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    wide ? BmiLayout.wideMaxWidth : BmiLayout.compactMaxWidth,
              ),
              child: wide
                  ? _WideBody(form: form, result: result, history: history)
                  : _CompactBody(form: form, result: result, history: history),
            ),
          ),
        );
      },
    );
  }
}

class _CompactBody extends StatelessWidget {
  const _CompactBody({
    required this.form,
    required this.result,
    required this.history,
  });

  final Widget form;
  final Widget result;
  final Widget? history;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        result,
        const SizedBox(height: AppSpacing.xlg),
        form,
        if (history != null) ...[
          const SizedBox(height: AppSpacing.lg),
          history!,
        ],
      ],
    );
  }
}

class _WideBody extends StatelessWidget {
  const _WideBody({
    required this.form,
    required this.result,
    required this.history,
  });

  final Widget form;
  final Widget result;
  final Widget? history;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 6, child: result),
            const SizedBox(width: AppSpacing.xlg),
            Expanded(flex: 5, child: form),
          ],
        ),
        if (history != null) ...[
          const SizedBox(height: AppSpacing.xlg),
          history!,
        ],
      ],
    );
  }
}
