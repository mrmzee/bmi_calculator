import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mrmzee_bmi_calculator/app/bmi_app.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/data/repositories/local_bmi_history_repository.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/data/services/bmi_history_local_service.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_view_model.dart';
import 'package:mrmzee_bmi_calculator/features/profile/data/repositories/local_profile_repository.dart';
import 'package:mrmzee_bmi_calculator/features/profile/data/services/profile_local_service.dart';
import 'package:mrmzee_bmi_calculator/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('cold start shows the profile setup form', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      BmiApp(
        viewModel: BmiViewModel(
          historyRepository: LocalBmiHistoryRepository(
            localService: BmiHistoryLocalService(preferences: preferences),
          ),
        ),
        profileViewModel: ProfileViewModel(
          repository: LocalProfileRepository(
            localService: ProfileLocalService(preferences: preferences),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('profile-setup-name')), findsOneWidget);
  });
}
