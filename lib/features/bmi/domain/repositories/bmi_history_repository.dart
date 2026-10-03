import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_history_entry.dart';

/// Persists recent BMI calculations on the device.
abstract interface class BmiHistoryRepository {
  Future<List<BmiHistoryEntry>> load();

  Future<void> save(BmiHistoryEntry entry);

  Future<void> clear();
}
