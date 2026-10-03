/// Age boundary between youth copy and WHO adult bands.
abstract final class BmiAgeBand {
  /// First age, in whole years, that uses adult classification.
  static const adultFromYears = 18;

  /// True when [ageYears] is known and still below [adultFromYears].
  ///
  /// A missing age keeps the stored adult classification for older saves.
  static bool isYouth(int? ageYears) {
    return ageYears != null && ageYears < adultFromYears;
  }
}
