import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_age_band.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_category.dart';

/// One saved BMI calculation for the local history list.
final class BmiHistoryEntry {
  const BmiHistoryEntry({
    required this.id,
    required this.recordedAt,
    required this.bmiValue,
    required this.category,
    required this.weightKg,
    required this.heightMeters,
    this.profileId = 'primary',
    this.ageYears,
  });

  final String id;
  final DateTime recordedAt;
  final double bmiValue;
  final BmiCategory category;
  final double weightKg;
  final double heightMeters;

  /// Owner of this calculation. Older saves without the field use `primary`.
  final String profileId;

  /// Age captured with this calculation. Null keeps the adult reading.
  final int? ageYears;

  bool get isYouth => BmiAgeBand.isYouth(ageYears);

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'recordedAt': recordedAt.toIso8601String(),
      'bmiValue': bmiValue,
      'category': category.name,
      'weightKg': weightKg,
      'heightMeters': heightMeters,
      'profileId': profileId,
      if (ageYears != null) 'ageYears': ageYears,
    };
  }

  static BmiHistoryEntry fromJson(Map<String, Object?> json) {
    return BmiHistoryEntry(
      id: json['id']! as String,
      recordedAt: DateTime.parse(json['recordedAt']! as String),
      bmiValue: (json['bmiValue']! as num).toDouble(),
      category: BmiCategory.values.byName(json['category']! as String),
      weightKg: (json['weightKg']! as num).toDouble(),
      heightMeters: (json['heightMeters']! as num).toDouble(),
      profileId: json['profileId'] as String? ?? 'primary',
      ageYears:
          json['ageYears'] is num ? (json['ageYears']! as num).toInt() : null,
    );
  }
}
