import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrmzee_bmi_calculator/features/profile/data/repositories/local_profile_repository.dart';
import 'package:mrmzee_bmi_calculator/features/profile/data/services/profile_local_service.dart';
import 'package:mrmzee_bmi_calculator/features/profile/domain/entities/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group(LocalProfileRepository, () {
    late LocalProfileRepository subject;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      subject = LocalProfileRepository(
        localService: ProfileLocalService(preferences: preferences),
      );
    });

    test('saves, selects, and deletes a profile', () async {
      const sara = Profile(id: 'sara', name: 'سارا', age: 28);
      await subject.save(const Profile(id: Profile.primaryId, name: 'من'));
      await subject.save(sara);
      await subject.writeActiveId(sara.id);

      expect(await subject.readActiveId(), 'sara');
      expect((await subject.load()).map((profile) => profile.name), [
        'من',
        'سارا',
      ]);
      expect((await subject.load()).last.age, 28);

      await subject
          .save(const Profile(id: 'sara', name: 'سارا رضایی', age: 29));
      expect((await subject.load()).last.name, 'سارا رضایی');
      expect((await subject.load()).last.age, 29);

      await subject.delete('sara');
      expect(await subject.load(), hasLength(1));
    });

    test('keeps a legacy profile that has no age', () async {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        ProfileLocalService.profilesKey,
        jsonEncode([
          {'id': 'legacy', 'name': 'من'},
        ]),
      );

      final legacy = await subject.load();

      expect(legacy.single.name, 'من');
      expect(legacy.single.age, isNull);
      expect(legacy.single.isComplete, isFalse);
    });
  });
}
