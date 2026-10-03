import 'package:flutter_test/flutter_test.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/data/repositories/local_bmi_history_repository.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/data/services/bmi_history_local_service.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_category.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_history_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group(LocalBmiHistoryRepository, () {
    late LocalBmiHistoryRepository subject;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      subject = LocalBmiHistoryRepository(
        localService: BmiHistoryLocalService(preferences: preferences),
        maxEntries: 2,
      );
    });

    test('saves newest first and respects maxEntries', () async {
      await subject.save(
        BmiHistoryEntry(
          id: '1',
          recordedAt: DateTime(2026, 1, 1),
          bmiValue: 22,
          category: BmiCategory.normal,
          weightKg: 70,
          heightMeters: 1.75,
        ),
      );
      await subject.save(
        BmiHistoryEntry(
          id: '2',
          recordedAt: DateTime(2026, 1, 2),
          bmiValue: 27,
          category: BmiCategory.overweight,
          weightKg: 85,
          heightMeters: 1.75,
        ),
      );
      await subject.save(
        BmiHistoryEntry(
          id: '3',
          recordedAt: DateTime(2026, 1, 3),
          bmiValue: 31,
          category: BmiCategory.obeseClass1,
          weightKg: 95,
          heightMeters: 1.75,
        ),
      );

      final history = await subject.load();

      expect(history, hasLength(2));
      expect(history.first.id, '3');
      expect(history.last.id, '2');
    });

    test('caps each profile separately', () async {
      Future<void> save(String id, String profileId, int day) {
        return subject.save(
          BmiHistoryEntry(
            id: id,
            profileId: profileId,
            recordedAt: DateTime(2026, 1, day),
            bmiValue: 22,
            category: BmiCategory.normal,
            weightKg: 70,
            heightMeters: 1.75,
          ),
        );
      }

      await save('1', 'a', 1);
      await save('2', 'a', 2);
      await save('3', 'a', 3);
      await save('4', 'b', 4);

      final history = await subject.load();

      expect(history.map((entry) => entry.id), ['4', '3', '2']);
    });

    test('delete and clearProfile leave the other entries', () async {
      await subject.save(
        BmiHistoryEntry(
          id: '1',
          profileId: 'a',
          recordedAt: DateTime(2026, 1, 1),
          bmiValue: 22,
          category: BmiCategory.normal,
          weightKg: 70,
          heightMeters: 1.75,
        ),
      );
      await subject.save(
        BmiHistoryEntry(
          id: '2',
          profileId: 'b',
          recordedAt: DateTime(2026, 1, 2),
          bmiValue: 24,
          category: BmiCategory.normal,
          weightKg: 74,
          heightMeters: 1.75,
        ),
      );

      await subject.delete('1');
      expect((await subject.load()).map((entry) => entry.id), ['2']);

      await subject.clearProfile('b');
      expect(await subject.load(), isEmpty);
    });

    test('clear removes all entries', () async {
      await subject.save(
        BmiHistoryEntry(
          id: '1',
          recordedAt: DateTime(2026, 1, 1),
          bmiValue: 22,
          category: BmiCategory.normal,
          weightKg: 70,
          heightMeters: 1.75,
        ),
      );

      await subject.clear();

      expect(await subject.load(), isEmpty);
    });
  });
}
