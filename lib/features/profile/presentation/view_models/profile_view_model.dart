import 'package:flutter/foundation.dart';
import 'package:mrmzee_bmi_calculator/features/profile/domain/entities/profile.dart';
import 'package:mrmzee_bmi_calculator/features/profile/domain/repositories/profile_repository.dart';
import 'package:mrmzee_bmi_calculator/features/profile/presentation/view_models/profile_state.dart';

/// Shown when a name is blank or an age is outside 2–120.
const invalidProfileInputMessage =
    'نام را بنویسید و سن را بین ۲ تا ۱۲۰ سال وارد کنید.';

/// Shown when a goal weight is outside 20–300 kg.
const invalidGoalWeightMessage = 'هدف وزن را بین ۲۰ تا ۳۰۰ کیلوگرم وارد کنید.';

/// Creates, edits, and selects the person a BMI calculation belongs to.
final class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    ProfileRepository? repository,
    String Function()? idFactory,
  })  : _repository = repository,
        _idFactory = idFactory ?? _defaultId;

  final ProfileRepository? _repository;
  final String Function() _idFactory;

  ProfileState _state = const ProfileState();

  ProfileState get state => _state;

  /// Loads saved people. An empty store stays empty.
  Future<void> load() async {
    final repository = _repository;
    if (repository == null) {
      _publish(
        profiles: _state.profiles,
        activeId: _resolvedActiveId(_state.profiles, _state.activeId),
      );
      return;
    }

    final profiles = await repository.load();
    final storedActiveId = await repository.readActiveId();
    final activeId = _resolvedActiveId(profiles, storedActiveId);
    if (activeId != null && activeId != storedActiveId) {
      await repository.writeActiveId(activeId);
    }
    _publish(profiles: profiles, activeId: activeId);
  }

  /// Adds [name] and [age], then selects that person.
  ///
  /// Returns false when the name is blank or the age is out of range.
  Future<bool> add({required String name, required int age}) async {
    final trimmed = name.trim();
    if (!_accepts(trimmed, age)) {
      return false;
    }
    final profile = Profile(id: _idFactory(), name: trimmed, age: age);
    final profiles = [..._state.profiles, profile];
    await _repository?.save(profile);
    await _repository?.writeActiveId(profile.id);
    _publish(profiles: profiles, activeId: profile.id);
    return true;
  }

  /// Replaces the name and age of an existing person.
  Future<bool> update({
    required String id,
    required String name,
    required int age,
  }) async {
    final trimmed = name.trim();
    if (!_accepts(trimmed, age)) {
      return false;
    }
    final current = _profileById(id);
    if (current == null) {
      return false;
    }
    final updated = Profile(
      id: id,
      name: trimmed,
      age: age,
      goalWeightKg: current.goalWeightKg,
    );
    final profiles = [
      for (final profile in _state.profiles)
        if (profile.id == id) updated else profile,
    ];
    await _repository?.save(updated);
    _publish(profiles: profiles, activeId: _state.activeId);
    return true;
  }

  /// Stores or clears a goal weight in kilograms.
  ///
  /// Pass null to clear the goal. Returns false when [kilograms] is out of
  /// range or [id] is unknown.
  Future<bool> setGoalWeight({
    required String id,
    required double? kilograms,
  }) async {
    if (kilograms != null && !Profile.isAcceptableGoal(kilograms)) {
      return false;
    }
    final current = _profileById(id);
    if (current == null) {
      return false;
    }
    final updated = Profile(
      id: current.id,
      name: current.name,
      age: current.age,
      goalWeightKg: kilograms,
    );
    final profiles = [
      for (final profile in _state.profiles)
        if (profile.id == id) updated else profile,
    ];
    await _repository?.save(updated);
    _publish(profiles: profiles, activeId: _state.activeId);
    return true;
  }

  Future<void> select(String id) async {
    if (id == _state.activeId) {
      return;
    }
    if (!_state.profiles.any((profile) => profile.id == id)) {
      return;
    }
    await _repository?.writeActiveId(id);
    _publish(profiles: _state.profiles, activeId: id);
  }

  /// Removes [id], including the last remaining profile.
  ///
  /// Returns the removed id, or null when [id] is unknown.
  Future<String?> remove(String id) async {
    if (!_state.profiles.any((profile) => profile.id == id)) {
      return null;
    }
    final profiles = [
      for (final profile in _state.profiles)
        if (profile.id != id) profile,
    ];
    await _repository?.delete(id);
    final activeId = _resolvedActiveId(
      profiles,
      _state.activeId == id ? null : _state.activeId,
    );
    if (activeId != null && activeId != _state.activeId) {
      await _repository?.writeActiveId(activeId);
    }
    _publish(profiles: profiles, activeId: activeId);
    return id;
  }

  Profile? _profileById(String id) {
    for (final profile in _state.profiles) {
      if (profile.id == id) {
        return profile;
      }
    }
    return null;
  }

  bool _accepts(String name, int age) {
    return name.isNotEmpty && Profile.isAcceptableAge(age);
  }

  String? _resolvedActiveId(List<Profile> profiles, String? activeId) {
    if (profiles.isEmpty) {
      return null;
    }
    if (activeId != null && profiles.any((profile) => profile.id == activeId)) {
      return activeId;
    }
    return profiles.first.id;
  }

  void _publish({
    required List<Profile> profiles,
    required String? activeId,
  }) {
    _state = ProfileState(
      profiles: profiles,
      activeId: activeId,
      isLoaded: true,
    );
    notifyListeners();
  }
}

var _profileIdSequence = 0;

String _defaultId() =>
    '${DateTime.now().microsecondsSinceEpoch}-${_profileIdSequence++}';
