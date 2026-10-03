import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mrmzee_bmi_calculator/app/bmi_app.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_category.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_category_message.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_status_palette.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_view_model.dart';
import 'package:mrmzee_bmi_calculator/features/profile/presentation/view_models/profile_view_model.dart';

void main() {
  group('BmiView', () {
    Future<void> pumpApp(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final profiles = ProfileViewModel(idFactory: () => 'sara');
      await profiles.add(name: 'سارا', age: 30);
      await tester.pumpWidget(
        BmiApp(
          viewModel: BmiViewModel(),
          profileViewModel: profiles,
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<void> enterAndCalculate(WidgetTester tester) async {
      await tester.enterText(find.byKey(const Key('weight-field')), '70');
      await tester.enterText(find.byKey(const Key('height-field')), '175');
      await tester.ensureVisible(find.byKey(const Key('calculate-button')));
      await tester.tap(find.byKey(const Key('calculate-button')));
      await tester.pumpAndSettle();
    }

    testWidgets('opens the result page after a calculation', (
      tester,
    ) async {
      await pumpApp(tester);

      expect(find.text(BmiCategory.normal.message), findsNothing);
      expect(find.byKey(const Key('weight-field')), findsOneWidget);

      await enterAndCalculate(tester);

      expect(find.text('22.86'), findsAtLeastNWidgets(1));
      expect(find.text(BmiCategory.normal.message), findsOneWidget);
      expect(find.textContaining('بازه وزن سالم'), findsOneWidget);
      expect(find.textContaining('جایگزین تشخیص پزشکی نیست'), findsOneWidget);

      final indicator = tester.widget<AnimatedContainer>(
        find.byKey(const Key('bmi-status-indicator')),
      );
      final decoration = indicator.decoration! as BoxDecoration;
      expect(decoration.color, BmiStatusColors.normal);
    });

    testWidgets('back from the result returns to an empty form', (
      tester,
    ) async {
      await pumpApp(tester);
      await enterAndCalculate(tester);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.text('آخرین سنجش'), findsOneWidget);
      expect(find.text('22.86'), findsOneWidget);
      expect(find.text(BmiCategory.normal.message), findsNothing);
      expect(find.text('70'), findsNothing);
      expect(find.text('175'), findsNothing);
      expect(find.byKey(const Key('weight-field')), findsOneWidget);
    });

    testWidgets('reset clears the measurement fields', (tester) async {
      await pumpApp(tester);
      await tester.enterText(find.byKey(const Key('weight-field')), '70');
      await tester.tap(find.byIcon(Icons.restart_alt_sharp));
      await tester.pumpAndSettle();

      expect(find.text('70'), findsNothing);
    });

    testWidgets('trend chart stays on the history tab', (tester) async {
      await pumpApp(tester);
      await enterAndCalculate(tester);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await enterAndCalculate(tester);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byWidgetPredicate(_isTrendChart), findsNothing);

      await tester.tap(find.text('تاریخچه'));
      await tester.pumpAndSettle();

      expect(find.byWidgetPredicate(_isTrendChart), findsOneWidget);
    });
  });
}

bool _isTrendChart(Widget widget) {
  return widget is Semantics &&
      widget.properties.label == 'نمودار روند شاخص توده بدنی';
}
