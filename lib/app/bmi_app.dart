import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_theme.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_view_model.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/bmi_view.dart';

class BmiApp extends StatelessWidget {
  const BmiApp({super.key, required this.viewModel});

  final BmiViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'شاخص توده بدنی',
      theme: BmiTheme.light,
      darkTheme: BmiTheme.dark,
      themeMode: ThemeMode.system,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: BmiView(viewModel: viewModel),
    );
  }
}
