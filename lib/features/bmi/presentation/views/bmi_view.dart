import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_unit.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_view_model.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_app_bar.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_backdrop.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_content.dart';
import 'package:share_plus/share_plus.dart';

/// BMI screen. Field controllers stay here; classification stays in the view model.
class BmiView extends StatefulWidget {
  const BmiView({super.key, required this.viewModel});

  final BmiViewModel viewModel;

  @override
  State<BmiView> createState() => _BmiViewState();
}

class _BmiViewState extends State<BmiView> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.loadHistory();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    await widget.viewModel.calculate(
      weightText: _weightController.text,
      heightText: _heightController.text,
    );
  }

  void _reset() {
    _weightController.clear();
    _heightController.clear();
    widget.viewModel.reset();
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

  Future<void> _share() async {
    final summary = widget.viewModel.shareSummary();
    await SharePlus.instance.share(ShareParams(text: summary));
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('پاک کردن تاریخچه'),
          content: const Text(
            'همهٔ محاسبه‌های ذخیره‌شده حذف می‌شوند. ادامه می‌دهید؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('انصراف'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('پاک کردن'),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      await widget.viewModel.clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final state = widget.viewModel.state;
        return Scaffold(
          body: Stack(
            children: [
              const Positioned.fill(child: BmiBackdrop()),
              SafeArea(
                child: Column(
                  children: [
                    BmiAppBar(
                      canShare: state.hasResult,
                      onShare: _share,
                      onReset: _reset,
                    ),
                    Expanded(
                      child: BmiContent(
                        state: state,
                        weightController: _weightController,
                        heightController: _heightController,
                        onWeightUnitChanged: _onWeightUnitChanged,
                        onHeightUnitChanged: _onHeightUnitChanged,
                        onCalculate: _calculate,
                        onClearHistory: _clearHistory,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
