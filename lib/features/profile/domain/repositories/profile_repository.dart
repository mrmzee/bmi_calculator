import 'package:mrmzee_bmi_calculator/features/profile/domain/entities/profile.dart';

/// Stores named people and which one is currently selected.
abstract interface class ProfileRepository {
  Future<List<Profile>> load();

  Future<void> save(Profile profile);

  Future<void> delete(String id);

  Future<String?> readActiveId();

  Future<void> writeActiveId(String id);
}
