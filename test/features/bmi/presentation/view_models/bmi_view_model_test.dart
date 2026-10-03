import 'package:flutter_test/flutter_test.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_category.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/measurement_unit.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_category_message.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_status.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_view_model.dart';

void main() {
  group(BmiViewModel, () {
    late BmiViewModel viewModel;

    setUp(() {
      viewModel = BmiViewModel(
        clock: () => DateTime(2026, 10, 3, 12),
        idFactory: () => 'fixed-id',
      );
    });

    test('starts empty with a zero value and no message', () {
      expect(viewModel.state.valueText, '0.00');
      expect(viewModel.state.message, isEmpty);
      expect(viewModel.state.status, BmiStatus.empty);
      expect(viewModel.state.bmi, isNull);
      expect(viewModel.state.heightUnit, HeightUnit.centimeter);
    });

    test('shows the incomplete message when a field is empty', () async {
      await viewModel.calculate(weightText: '', heightText: '175');

      expect(viewModel.state.message, incompleteInputMessage);
      expect(viewModel.state.bmi, isNull);
      expect(viewModel.state.status, BmiStatus.empty);
    });

    test('shows the not-numeric message for non-numeric text', () async {
      await viewModel.calculate(weightText: 'abc', heightText: '175');

      expect(viewModel.state.message, notNumericInputMessage);
    });

    test('classifies normal, overweight, and underweight readings', () async {
      await viewModel.calculate(weightText: '70', heightText: '175');
      expect(viewModel.state.valueText, '22.86');
      expect(viewModel.state.message, BmiCategory.normal.message);
      expect(viewModel.state.status, BmiStatus.normal);
      expect(viewModel.state.healthyWeightMessage, contains('کیلوگرم'));

      await viewModel.calculate(weightText: '80', heightText: '170');
      expect(viewModel.state.message, BmiCategory.overweight.message);
      expect(viewModel.state.status, BmiStatus.overweight);

      await viewModel.calculate(weightText: '54', heightText: '175');
      expect(viewModel.state.message, BmiCategory.mildThinness.message);
      expect(viewModel.state.status, BmiStatus.mildThinness);
    });

    test('rejects zero weight as out of range', () async {
      await viewModel.calculate(weightText: '0', heightText: '180');

      expect(viewModel.state.message, weightOutOfRangeMessage);
      expect(viewModel.state.bmi, isNull);
    });

    test('accepts Persian digits and converts display units', () async {
      await viewModel.calculate(weightText: '۷۰', heightText: '۱۷۵');
      expect(viewModel.state.valueText, '22.86');
      expect(viewModel.state.status, BmiStatus.normal);

      viewModel.setHeightUnit(HeightUnit.meter);
      await viewModel.calculate(weightText: '70', heightText: '1.75');
      expect(viewModel.state.valueText, '22.86');
    });

    test('converts field text when switching weight units', () {
      final converted = viewModel.convertWeightFieldText(
        '70',
        WeightUnit.pound,
      );

      expect(double.parse(converted), closeTo(154.3, 0.1));
    });

    test('keeps history in memory when no repository is provided', () async {
      await viewModel.calculate(weightText: '70', heightText: '175');

      expect(viewModel.state.history, hasLength(1));
      expect(viewModel.state.history.first.bmiValue, closeTo(22.86, 0.01));
      expect(viewModel.state.history.first.profileId, 'primary');
    });

    test('stores the active profile and returns the entry id', () async {
      viewModel.setProfileId('sara');

      final id = await viewModel.calculate(weightText: '70', heightText: '175');

      expect(id, 'fixed-id');
      expect(viewModel.state.history.single.profileId, 'sara');
    });

    test('clearHistoryFor keeps other profiles', () async {
      var tick = 0;
      final scoped = BmiViewModel(
        clock: () => DateTime(2026, 10, 3, 12),
        idFactory: () => 'id-${tick++}',
      );
      scoped.setProfileId('a');
      await scoped.calculate(weightText: '70', heightText: '175');
      scoped.setProfileId('b');
      await scoped.calculate(weightText: '80', heightText: '170');

      await scoped.clearHistoryFor('a');

      expect(scoped.state.history, hasLength(1));
      expect(scoped.state.history.single.profileId, 'b');
    });

    test('youth results skip adult bands and adults start at 18', () async {
      viewModel.setProfileAge(17);
      await viewModel.calculate(weightText: '70', heightText: '175');

      expect(viewModel.state.isYouth, isTrue);
      expect(viewModel.state.status, BmiStatus.youth);
      expect(viewModel.state.healthyWeightMessage, isEmpty);
      expect(viewModel.state.message, youthResultMessage);
      expect(viewModel.state.history.single.ageYears, 17);

      viewModel.setProfileAge(18);
      await viewModel.calculate(weightText: '70', heightText: '175');

      expect(viewModel.state.isYouth, isFalse);
      expect(viewModel.state.status, BmiStatus.normal);
      expect(viewModel.state.healthyWeightMessage, isNotEmpty);
      expect(viewModel.state.history.first.ageYears, 18);
    });

    test('shareSummary includes category and disclaimer', () async {
      await viewModel.calculate(weightText: '70', heightText: '175');

      final summary = viewModel.shareSummary();
      expect(summary, contains('22.86'));
      expect(summary, contains(BmiCategory.normal.message));
      expect(summary, contains(medicalDisclaimerMessage));
    });

    test('reset clears a previous result and keeps history', () async {
      await viewModel.calculate(weightText: '70', heightText: '175');

      viewModel.reset();

      expect(viewModel.state.bmi, isNull);
      expect(viewModel.state.message, isEmpty);
      expect(viewModel.state.status, BmiStatus.empty);
      expect(viewModel.state.history, hasLength(1));
    });
  });
}
