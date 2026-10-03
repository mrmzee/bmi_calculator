import 'package:flutter_test/flutter_test.dart';
import 'package:mrmzee_bmi_calculator/features/profile/presentation/view_models/profile_view_model.dart';

void main() {
  group(ProfileViewModel, () {
    late ProfileViewModel viewModel;

    setUp(() {
      var tick = 0;
      viewModel = ProfileViewModel(idFactory: () => 'id-${tick++}');
    });

    test('starts with no profile', () {
      expect(viewModel.state.profiles, isEmpty);
      expect(viewModel.state.active, isNull);
      expect(viewModel.state.isLoaded, isFalse);
      expect(viewModel.state.hasCompleteProfile, isFalse);
    });

    test('add selects the new person and ignores invalid input', () async {
      expect(await viewModel.add(name: '   ', age: 30), isFalse);
      expect(await viewModel.add(name: 'سارا', age: 1), isFalse);
      expect(await viewModel.add(name: 'سارا', age: 121), isFalse);
      expect(viewModel.state.profiles, isEmpty);

      expect(await viewModel.add(name: ' سارا ', age: 30), isTrue);

      expect(viewModel.state.profiles, hasLength(1));
      expect(viewModel.state.active?.name, 'سارا');
      expect(viewModel.state.active?.age, 30);
      expect(viewModel.state.active?.id, 'id-0');
      expect(viewModel.state.hasCompleteProfile, isTrue);
    });

    test('remove drops the last profile and switches the active one', () async {
      await viewModel.add(name: 'سارا', age: 30);
      await viewModel.add(name: 'رضا', age: 40);
      await viewModel.remove('id-0');

      expect(viewModel.state.profiles.single.name, 'رضا');
      expect(viewModel.state.active?.name, 'رضا');

      expect(await viewModel.remove('id-1'), 'id-1');
      expect(viewModel.state.profiles, isEmpty);
      expect(viewModel.state.active, isNull);
      expect(viewModel.state.hasCompleteProfile, isFalse);
    });

    test('update changes the selected profile', () async {
      await viewModel.add(name: 'سارا', age: 30);

      expect(
        await viewModel.update(id: 'id-0', name: 'رضا', age: 31),
        isTrue,
      );

      expect(viewModel.state.active?.name, 'رضا');
      expect(viewModel.state.active?.age, 31);
    });

    test('setGoalWeight keeps the goal when the name changes', () async {
      await viewModel.add(name: 'سارا', age: 30);

      expect(
        await viewModel.setGoalWeight(id: 'id-0', kilograms: 68),
        isTrue,
      );
      expect(await viewModel.setGoalWeight(id: 'id-0', kilograms: 10), isFalse);
      expect(
        await viewModel.update(id: 'id-0', name: 'رضا', age: 31),
        isTrue,
      );

      expect(viewModel.state.active?.goalWeightKg, 68);
    });
  });
}
