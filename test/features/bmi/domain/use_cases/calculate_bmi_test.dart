import 'package:flutter_test/flutter_test.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_category.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/use_cases/calculate_bmi.dart';

void main() {
  group(CalculateBmi, () {
    const calculateBmi = CalculateBmi();

    test('divides weight by height squared', () {
      final bmi = calculateBmi(
        const CalculateBmiRequest(weightKg: 70, heightMeters: 1.75),
      );

      expect(bmi.value, closeTo(22.86, 0.01));
      expect(bmi.category, BmiCategory.normal);
    });
  });
}
