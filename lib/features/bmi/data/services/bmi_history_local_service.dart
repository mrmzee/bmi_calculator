import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Raw JSON persistence for BMI history entries.
final class BmiHistoryLocalService {
  BmiHistoryLocalService({SharedPreferences? preferences})
      : _preferences = preferences;

  static const storageKey = 'bmi_history_entries';

  SharedPreferences? _preferences;

  Future<SharedPreferences> _prefs() async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  Future<List<Map<String, Object?>>> readEntries() async {
    final raw = (await _prefs()).getString(storageKey);
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

  Future<void> writeEntries(List<Map<String, Object?>> entries) async {
    await (await _prefs()).setString(storageKey, jsonEncode(entries));
  }

  Future<void> clear() async {
    await (await _prefs()).remove(storageKey);
  }
}
