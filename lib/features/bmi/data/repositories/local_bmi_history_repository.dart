import 'package:mrmzee_bmi_calculator/features/bmi/data/services/bmi_history_local_service.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_history_entry.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/repositories/bmi_history_repository.dart';

/// Device-local BMI history capped at [maxEntries].
final class LocalBmiHistoryRepository implements BmiHistoryRepository {
  LocalBmiHistoryRepository({
    BmiHistoryLocalService? localService,
    this.maxEntries = 20,
  }) : _localService = localService ?? BmiHistoryLocalService();

  final BmiHistoryLocalService _localService;
  final int maxEntries;

  @override
  Future<List<BmiHistoryEntry>> load() async {
    final raw = await _localService.readEntries();
    final entries = <BmiHistoryEntry>[];
    for (final item in raw) {
      try {
        entries.add(BmiHistoryEntry.fromJson(item));
      } on Object {
        // Skip corrupt rows so one bad value does not wipe history.
      }
    }
    entries.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    return entries;
  }

  @override
  Future<void> save(BmiHistoryEntry entry) async {
    final current = await load();
    final next = [entry, ...current.where((item) => item.id != entry.id)];
    final sameProfile = next
        .where((item) => item.profileId == entry.profileId)
        .take(maxEntries);
    final otherProfiles =
        next.where((item) => item.profileId != entry.profileId);
    await _write([...sameProfile, ...otherProfiles]);
  }

  @override
  Future<void> delete(String id) async {
    final current = await load();
    await _write([
      for (final item in current)
        if (item.id != id) item,
    ]);
  }

  @override
  Future<void> clearProfile(String profileId) async {
    final current = await load();
    await _write([
      for (final item in current)
        if (item.profileId != profileId) item,
    ]);
  }

  @override
  Future<void> clear() => _localService.clear();

  Future<void> _write(List<BmiHistoryEntry> entries) {
    return _localService.writeEntries([
      for (final item in entries) item.toJson(),
    ]);
  }
}
