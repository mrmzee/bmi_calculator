import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Raw JSON persistence for named BMI profiles.
final class ProfileLocalService {
  ProfileLocalService({SharedPreferences? preferences})
      : _preferences = preferences;

  static const profilesKey = 'bmi_profiles';
  static const activeIdKey = 'bmi_active_profile_id';

  SharedPreferences? _preferences;

  Future<SharedPreferences> _prefs() async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  Future<List<Map<String, Object?>>> readProfiles() async {
    final raw = (await _prefs()).getString(profilesKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return const [];
    }
    return [
      for (final item in decoded)
        if (item is Map)
          item.map((key, value) => MapEntry(key.toString(), value)),
    ];
  }

  Future<void> writeProfiles(List<Map<String, Object?>> profiles) async {
    await (await _prefs()).setString(profilesKey, jsonEncode(profiles));
  }

  Future<String?> readActiveId() async {
    return (await _prefs()).getString(activeIdKey);
  }

  Future<void> writeActiveId(String id) async {
    await (await _prefs()).setString(activeIdKey, id);
  }
}
