import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/app/bmi_app.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/data/repositories/local_bmi_history_repository.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/use_cases/calculate_bmi.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/use_cases/compute_healthy_weight_range.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/use_cases/validate_measurements.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BmiApp(
      viewModel: BmiViewModel(
        calculateBmi: const CalculateBmi(),
        computeHealthyWeightRange: const ComputeHealthyWeightRange(),
        validateMeasurements: const ValidateMeasurements(),
        historyRepository: LocalBmiHistoryRepository(),
      ),
    ),
  );
}
