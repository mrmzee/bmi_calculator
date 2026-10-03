import 'package:mrmzee_bmi_calculator/features/profile/data/services/profile_local_service.dart';
import 'package:mrmzee_bmi_calculator/features/profile/domain/entities/profile.dart';
import 'package:mrmzee_bmi_calculator/features/profile/domain/repositories/profile_repository.dart';

/// Device-local profiles backed by [ProfileLocalService].
final class LocalProfileRepository implements ProfileRepository {
  LocalProfileRepository({ProfileLocalService? localService})
      : _localService = localService ?? ProfileLocalService();

  final ProfileLocalService _localService;

  @override
  Future<List<Profile>> load() async {
    final raw = await _localService.readProfiles();
    final profiles = <Profile>[];
    for (final item in raw) {
      try {
        profiles.add(Profile.fromJson(item));
      } on Object {
        // Skip corrupt rows so one bad value does not wipe the list.
      }
    }
    return profiles;
  }

  @override
  Future<void> save(Profile profile) async {
    final current = await load();
    final index = current.indexWhere((item) => item.id == profile.id);
    if (index == -1) {
      current.add(profile);
    } else {
      current[index] = profile;
    }
    await _localService.writeProfiles([
      for (final item in current) item.toJson(),
    ]);
  }

  @override
  Future<void> delete(String id) async {
    final current = await load();
    await _localService.writeProfiles([
      for (final item in current)
        if (item.id != id) item.toJson(),
    ]);
  }

  @override
  Future<String?> readActiveId() => _localService.readActiveId();

  @override
  Future<void> writeActiveId(String id) => _localService.writeActiveId(id);
}
