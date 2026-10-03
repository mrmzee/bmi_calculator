/// A person who keeps a separate BMI history on this device.
final class Profile {
  const Profile({
    required this.id,
    required this.name,
    this.age,
    this.goalWeightKg,
  });

  /// Id used by history entries saved before profiles existed.
  static const primaryId = 'primary';

  /// Youngest age this app accepts on a profile.
  static const minimumAge = 2;

  /// Oldest age this app accepts on a profile.
  static const maximumAge = 120;

  final String id;
  final String name;

  /// Whole years. Null means a saved profile still needs an age.
  final int? age;

  /// Optional target weight in kilograms.
  final double? goalWeightKg;

  bool get isComplete => age != null;

  /// Lightest goal this app stores.
  static const minimumGoalKg = 20.0;

  /// Heaviest goal this app stores.
  static const maximumGoalKg = 300.0;

  static bool isAcceptableGoal(double kilograms) {
    return kilograms >= minimumGoalKg && kilograms <= maximumGoalKg;
  }

  static bool isAcceptableAge(int age) {
    return age >= minimumAge && age <= maximumAge;
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      if (age != null) 'age': age,
      if (goalWeightKg != null) 'goalWeightKg': goalWeightKg,
    };
  }

  static Profile fromJson(Map<String, Object?> json) {
    final rawAge = json['age'];
    final rawGoal = json['goalWeightKg'];
    return Profile(
      id: json['id']! as String,
      name: json['name']! as String,
      age: rawAge is num ? rawAge.toInt() : null,
      goalWeightKg: rawGoal is num ? rawGoal.toDouble() : null,
    );
  }
}
