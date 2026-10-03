import 'package:flutter_test/flutter_test.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_category.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/use_cases/interpret_bmi.dart';

void main() {
  group(InterpretBmi, () {
    const interpret = InterpretBmi();
    const bmi = Bmi(value: 70 / (1.75 * 1.75));

    test('adult bands start at 18 and youth is below that', () {
      final youth = interpret(bmi: bmi, ageYears: 17);
      expect(youth.isYouth, isTrue);
      expect(youth.category, isNull);

      final adult = interpret(bmi: bmi, ageYears: 18);
      expect(adult.isYouth, isFalse);
      expect(adult.category, BmiCategory.normal);

      final legacy = interpret(bmi: bmi, ageYears: null);
      expect(legacy.isYouth, isFalse);
      expect(legacy.category, BmiCategory.normal);
    });
  });
}
