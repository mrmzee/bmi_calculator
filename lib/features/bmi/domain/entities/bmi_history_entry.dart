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
  });

  final String id;
  final DateTime recordedAt;
  final double bmiValue;
  final BmiCategory category;
  final double weightKg;
  final double heightMeters;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'recordedAt': recordedAt.toIso8601String(),
      'bmiValue': bmiValue,
      'category': category.name,
      'weightKg': weightKg,
      'heightMeters': heightMeters,
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
    );
  }
}
