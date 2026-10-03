import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_app_bar.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_backdrop.dart';

/// Backdrop, safe area, and a header above the page body.
class BmiPage extends StatelessWidget {
  const BmiPage({
    super.key,
    required this.header,
    required this.body,
    this.footer,
    this.includeBottomInset = false,
  });

  final BmiAppBar header;
  final Widget body;
  final Widget? footer;

  /// Keeps content above the system inset when this page has no bottom bar.
  final bool includeBottomInset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: BmiBackdrop()),
        SafeArea(
          bottom: includeBottomInset,
          child: Column(
            children: [
              header,
              Expanded(child: body),
              if (footer != null) footer!,
            ],
          ),
        ),
      ],
    );
  }
}
