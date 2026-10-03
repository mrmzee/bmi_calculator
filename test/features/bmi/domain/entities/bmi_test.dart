import 'package:flutter_test/flutter_test.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_category.dart';

void main() {
  group(Bmi, () {
    group('category', () {
      test('uses WHO adult bands including obesity classes', () {
        expect(const Bmi(value: 15.9).category, BmiCategory.severeThinness);
        expect(const Bmi(value: 16).category, BmiCategory.moderateThinness);
        expect(const Bmi(value: 17).category, BmiCategory.mildThinness);
        expect(const Bmi(value: 18.5).category, BmiCategory.normal);
        expect(const Bmi(value: 24.9).category, BmiCategory.normal);
        expect(const Bmi(value: 25).category, BmiCategory.overweight);
        expect(const Bmi(value: 30).category, BmiCategory.obeseClass1);
        expect(const Bmi(value: 35).category, BmiCategory.obeseClass2);
        expect(const Bmi(value: 40).category, BmiCategory.obeseClass3);
      });
    });
  });
}
