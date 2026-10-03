import 'package:mrmzee_bmi_calculator/features/profile/domain/entities/profile.dart';

/// Profiles available on this device and the one currently selected.
final class ProfileState {
  const ProfileState({
    this.profiles = const [],
    this.activeId,
    this.isLoaded = false,
  });

  final List<Profile> profiles;
  final String? activeId;

  /// False until the first load from storage finishes.
  final bool isLoaded;

  Profile? get active {
    for (final profile in profiles) {
      if (profile.id == activeId) {
        return profile;
      }
    }
    if (profiles.isEmpty) {
      return null;
    }
    return profiles.first;
  }

  /// True when the selected person has both a name and an age.
  bool get hasCompleteProfile => active?.isComplete ?? false;
}
