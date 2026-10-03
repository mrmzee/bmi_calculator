import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_history_entry.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_unit.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_layout.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_view_model.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_app_bar.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_content.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_page.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/calculate_bmi_button.dart';
import 'package:mrmzee_bmi_calculator/features/profile/presentation/view_models/profile_view_model.dart';

/// Measurement screen. A successful calculation opens the result route.
class BmiView extends StatefulWidget {
  const BmiView({
    super.key,
    required this.viewModel,
    required this.profiles,
  });

  final BmiViewModel viewModel;
  final ProfileViewModel profiles;

  @override
  State<BmiView> createState() => _BmiViewState();
}

class _BmiViewState extends State<BmiView> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.profiles.addListener(_syncProfile);
    _syncProfile();
    widget.viewModel.loadHistory();
  }

  @override
  void dispose() {
    widget.profiles.removeListener(_syncProfile);
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _syncProfile() {
    final active = widget.profiles.state.active;
    if (active == null) {
      return;
    }
    widget.viewModel.setProfileId(active.id);
    widget.viewModel.setProfileAge(active.age);
  }

  Future<void> _calculate() async {
    final id = await widget.viewModel.calculate(
      weightText: _weightController.text,
      heightText: _heightController.text,
    );
    if (!mounted || id == null) {
      return;
    }
    HapticFeedback.lightImpact().ignore();
    _weightController.clear();
    _heightController.clear();
    await context.push('/results/$id');
  }

  void _reset() {
    _weightController.clear();
    _heightController.clear();
    widget.viewModel.reset();
  }

  List<BmiHistoryEntry> _profileHistory() {
    final activeId = widget.profiles.state.active?.id;
    if (activeId == null) {
      return const [];
    }
    return [
      for (final entry in widget.viewModel.state.history)
        if (entry.profileId == activeId) entry,
    ];
  }

  void _onWeightUnitChanged(WeightUnit unit) {
    final converted = widget.viewModel.convertWeightFieldText(
      _weightController.text,
      unit,
    );
    widget.viewModel.setWeightUnit(unit);
    _weightController.value = TextEditingValue(
      text: converted,
      selection: TextSelection.collapsed(offset: converted.length),
    );
  }

  void _onHeightUnitChanged(HeightUnit unit) {
    final converted = widget.viewModel.convertHeightFieldText(
      _heightController.text,
      unit,
    );
    widget.viewModel.setHeightUnit(unit);
    _heightController.value = TextEditingValue(
      text: converted,
      selection: TextSelection.collapsed(offset: converted.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([widget.viewModel, widget.profiles]),
      builder: (context, _) {
        final state = widget.viewModel.state;
        final history = _profileHistory();
        return BmiPage(
          header: BmiAppBar(
            eyebrow: widget.profiles.state.active?.name ?? '',
            onReset: _reset,
          ),
          body: BmiContent(
            state: state,
            weightController: _weightController,
            heightController: _heightController,
            onWeightUnitChanged: _onWeightUnitChanged,
            onHeightUnitChanged: _onHeightUnitChanged,
            latest: history.isEmpty ? null : history.first,
            previous: history.length < 2 ? null : history[1],
            goalWeightKg: widget.profiles.state.active?.goalWeightKg,
            onOpenLatest: history.isEmpty
                ? null
                : () => context.push('/results/${history.first.id}'),
          ),
          footer: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: AppSpacing.lg,
              end: AppSpacing.lg,
              top: AppSpacing.sm,
              bottom: AppSpacing.md,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: BmiLayout.compactMaxWidth,
                ),
                child: CalculateBmiButton(onPressed: _calculate),
              ),
            ),
          ),
        );
      },
    );
  }
}
