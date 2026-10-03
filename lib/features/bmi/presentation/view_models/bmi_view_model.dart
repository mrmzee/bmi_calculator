import 'package:flutter/foundation.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_history_entry.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_unit.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_validation.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/repositories/bmi_history_repository.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/use_cases/calculate_bmi.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/use_cases/compute_healthy_weight_range.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/use_cases/validate_measurements.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_category_message.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_state.dart';

/// Holds the BMI screen state and turns field text into a [BmiState].
final class BmiViewModel extends ChangeNotifier {
  BmiViewModel({
    CalculateBmi calculateBmi = const CalculateBmi(),
    ComputeHealthyWeightRange computeHealthyWeightRange =
        const ComputeHealthyWeightRange(),
    ValidateMeasurements validateMeasurements = const ValidateMeasurements(),
    BmiHistoryRepository? historyRepository,
    DateTime Function()? clock,
    String Function()? idFactory,
  })  : _calculateBmi = calculateBmi,
        _computeHealthyWeightRange = computeHealthyWeightRange,
        _validateMeasurements = validateMeasurements,
        _historyRepository = historyRepository,
        _clock = clock ?? DateTime.now,
        _idFactory = idFactory ?? _defaultId;

  final CalculateBmi _calculateBmi;
  final ComputeHealthyWeightRange _computeHealthyWeightRange;
  final ValidateMeasurements _validateMeasurements;
  final BmiHistoryRepository? _historyRepository;
  final DateTime Function() _clock;
  final String Function() _idFactory;

  BmiState _state = const BmiState();

  BmiState get state => _state;

  /// Loads persisted history once the screen is ready.
  Future<void> loadHistory() async {
    final repository = _historyRepository;
    if (repository == null) {
      return;
    }
    _state = _state.copyWith(isHistoryLoading: true);
    notifyListeners();
    final history = await repository.load();
    _state = _state.copyWith(history: history, isHistoryLoading: false);
    notifyListeners();
  }

  Future<void> calculate({
    required String weightText,
    required String heightText,
  }) async {
    final weightHadText = weightText.trim().isNotEmpty;
    final heightHadText = heightText.trim().isNotEmpty;
    final parsedWeight = parseMeasurementText(weightText);
    final parsedHeight = parseMeasurementText(heightText);

    final weightKg = parsedWeight == null
        ? null
        : MeasurementConverter.kilogramsFrom(parsedWeight, _state.weightUnit);
    final heightMeters = parsedHeight == null
        ? null
        : MeasurementConverter.metersFrom(parsedHeight, _state.heightUnit);

    final validation = _validateMeasurements(
      weightKg: weightKg,
      heightMeters: heightMeters,
      weightHadText: weightHadText,
      heightHadText: heightHadText,
    );

    if (validation is MeasurementValidationFailure) {
      _state = BmiState(
        message: messageForValidationError(validation.error),
        weightUnit: _state.weightUnit,
        heightUnit: _state.heightUnit,
        history: _state.history,
        isHistoryLoading: _state.isHistoryLoading,
      );
      notifyListeners();
      return;
    }

    final success = validation as MeasurementValidationSuccess;
    final bmi = _calculateBmi(
      CalculateBmiRequest(
        weightKg: success.weightKg,
        heightMeters: success.heightMeters,
      ),
    );
    final range = _computeHealthyWeightRange(success.heightMeters);
    final healthyMessage = healthyWeightRangeMessage(
      minKg: range.minKg,
      maxKg: range.maxKg,
      weightKg: success.weightKg,
    );

    final entry = BmiHistoryEntry(
      id: _idFactory(),
      recordedAt: _clock(),
      bmiValue: bmi.value,
      category: bmi.category,
      weightKg: success.weightKg,
      heightMeters: success.heightMeters,
    );

    var history = _state.history;
    final repository = _historyRepository;
    if (repository != null) {
      await repository.save(entry);
      history = await repository.load();
    } else {
      history = [entry, ...history].take(20).toList(growable: false);
    }

    _state = BmiState(
      bmi: bmi,
      message: bmi.category.message,
      healthyWeightRange: range,
      healthyWeightMessage: healthyMessage,
      weightKg: success.weightKg,
      heightMeters: success.heightMeters,
      weightUnit: _state.weightUnit,
      heightUnit: _state.heightUnit,
      history: history,
      isHistoryLoading: false,
    );
    notifyListeners();
  }

  void setWeightUnit(WeightUnit unit) {
    if (unit == _state.weightUnit) {
      return;
    }
    _state = _state.copyWith(weightUnit: unit);
    notifyListeners();
  }

  void setHeightUnit(HeightUnit unit) {
    if (unit == _state.heightUnit) {
      return;
    }
    _state = _state.copyWith(heightUnit: unit);
    notifyListeners();
  }

  /// Converts the visible field text when the user switches units.
  String convertWeightFieldText(String text, WeightUnit nextUnit) {
    final parsed = parseMeasurementText(text);
    if (parsed == null) {
      return text;
    }
    final kilograms = MeasurementConverter.kilogramsFrom(
      parsed,
      _state.weightUnit,
    );
    final displayed = MeasurementConverter.displayWeight(kilograms, nextUnit);
    return _formatFieldNumber(displayed);
  }

  String convertHeightFieldText(String text, HeightUnit nextUnit) {
    final parsed = parseMeasurementText(text);
    if (parsed == null) {
      return text;
    }
    final meters = MeasurementConverter.metersFrom(parsed, _state.heightUnit);
    final displayed = MeasurementConverter.displayHeight(meters, nextUnit);
    return _formatFieldNumber(displayed);
  }

  Future<void> clearHistory() async {
    final repository = _historyRepository;
    if (repository != null) {
      await repository.clear();
    }
    _state = _state.copyWith(history: const []);
    notifyListeners();
  }

  void reset() {
    _state = BmiState(
      weightUnit: _state.weightUnit,
      heightUnit: _state.heightUnit,
      history: _state.history,
    );
    notifyListeners();
  }

  /// Plain-text summary for the system share sheet.
  String shareSummary() {
    final reading = _state.bmi;
    if (reading == null) {
      return 'محاسبه‌گر شاخص توده بدنی';
    }
    final buffer = StringBuffer()
      ..writeln('شاخص توده بدنی: ${reading.value.toStringAsFixed(2)}')
      ..writeln(_state.message);
    if (_state.healthyWeightMessage.isNotEmpty) {
      buffer.writeln(_state.healthyWeightMessage);
    }
    buffer.writeln(medicalDisclaimerMessage);
    return buffer.toString().trim();
  }
}

String _defaultId() => DateTime.now().microsecondsSinceEpoch.toString();

String _formatFieldNumber(double value) {
  if ((value - value.roundToDouble()).abs() < 0.001) {
    return value.round().toString();
  }
  return value.toStringAsFixed(value >= 10 ? 1 : 2);
}

const _persianDigits = '۰۱۲۳۴۵۶۷۸۹';
const _arabicDigits = '٠١٢٣٤٥٦٧٨٩';

/// Reads a measurement field.
///
/// Persian and Arabic digits are accepted. `,` and `٫` count as a decimal point.
double? parseMeasurementText(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  final buffer = StringBuffer();
  for (final codeUnit in trimmed.runes) {
    final character = String.fromCharCode(codeUnit);
    final persianIndex = _persianDigits.indexOf(character);
    if (persianIndex != -1) {
      buffer.write(persianIndex);
      continue;
    }
    final arabicIndex = _arabicDigits.indexOf(character);
    if (arabicIndex != -1) {
      buffer.write(arabicIndex);
      continue;
    }
    if (character == ',' || character == '٫' || character == '،') {
      buffer.write('.');
      continue;
    }
    buffer.write(character);
  }
  return double.tryParse(buffer.toString());
}
