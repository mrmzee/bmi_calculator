import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrmzee_bmi_calculator/app/bmi_router.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_theme.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_view_model.dart';
import 'package:mrmzee_bmi_calculator/features/profile/presentation/view_models/profile_view_model.dart';

class BmiApp extends StatefulWidget {
  const BmiApp({
    super.key,
    required this.viewModel,
    this.profileViewModel,
  });

  final BmiViewModel viewModel;
  final ProfileViewModel? profileViewModel;

  @override
  State<BmiApp> createState() => _BmiAppState();
}

class _BmiAppState extends State<BmiApp> {
  late final ProfileViewModel _profiles;
  late final bool _ownsProfiles;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _ownsProfiles = widget.profileViewModel == null;
    _profiles = widget.profileViewModel ?? ProfileViewModel();
    _router = createBmiRouter(
      calculator: widget.viewModel,
      profiles: _profiles,
    );
    _profiles.load();
  }

  @override
  void dispose() {
    _router.dispose();
    if (_ownsProfiles) {
      _profiles.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'شاخص توده بدنی',
      theme: BmiTheme.light,
      darkTheme: BmiTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
