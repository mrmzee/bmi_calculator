import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mrmzee_bmi_calculator/app/bmi_app.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_view_model.dart';

void main() {
  testWidgets('phone, short, and wide layouts do not overflow', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final sizes = [
      const Size(320, 640),
      const Size(390, 844),
      const Size(1100, 800),
    ];

    for (final size in sizes) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(BmiApp(viewModel: BmiViewModel()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: '$size');
      expect(find.byKey(const Key('weight-field')), findsOneWidget);
      expect(find.byKey(const Key('calculate-button')), findsOneWidget);
    }
  });
}
