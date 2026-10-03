import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_reading_copy.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_result_details.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_layout.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_view_model.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_app_bar.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_page.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_result_panel.dart';
import 'package:mrmzee_bmi_calculator/features/profile/domain/entities/profile.dart';
import 'package:mrmzee_bmi_calculator/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:share_plus/share_plus.dart';

/// Dial, category, and healthy-weight note for one saved calculation.
class BmiResultView extends StatelessWidget {
  const BmiResultView({
    super.key,
    required this.entryId,
    required this.viewModel,
    required this.profiles,
  });

  final String entryId;
  final BmiViewModel viewModel;
  final ProfileViewModel profiles;

  static final _shareBoundary = GlobalKey();

  Profile? _owner(String profileId) {
    for (final profile in profiles.state.profiles) {
      if (profile.id == profileId) {
        return profile;
      }
    }
    return null;
  }

  Future<void> _share({
    required String summary,
  }) async {
    final boundary = _shareBoundary.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary != null) {
      try {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        if (bytes != null) {
          await SharePlus.instance.share(
            ShareParams(
              text: summary,
              files: [
                XFile.fromData(
                  bytes.buffer.asUint8List(),
                  mimeType: 'image/png',
                  name: 'bmi.png',
                ),
              ],
            ),
          );
          return;
        }
      } on Object {
        // The text summary still leaves with the system share sheet.
      }
    }
    await SharePlus.instance.share(ShareParams(text: summary));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appCanvas.canvas,
      body: ListenableBuilder(
        listenable: Listenable.merge([viewModel, profiles]),
        builder: (context, _) {
          final entry = viewModel.entryById(entryId);
          if (entry == null) {
            return const BmiPage(
              includeBottomInset: true,
              header: BmiAppBar(
                eyebrow: 'شاخص توده بدنی',
                title: 'نتیجه',
                leading: BackButton(),
              ),
              body: Center(child: Text('این نتیجه دیگر در تاریخچه نیست.')),
            );
          }

          final state = stateForHistoryEntry(entry);
          final owner = _owner(entry.profileId);
          final goal = owner?.goalWeightKg;
          final weight = state.weightKg;
          final goalLine = goal == null || weight == null
              ? null
              : goalDistanceLabel(goalKg: goal, weightKg: weight);
          return BmiPage(
            includeBottomInset: true,
            header: BmiAppBar(
              eyebrow: owner?.name ?? 'شاخص توده بدنی',
              title: 'نتیجه',
              leading: const BackButton(),
              canShare: true,
              onShare: () => _share(
                summary: shareSummaryFor(state, goalLine: goalLine),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: BmiLayout.compactMaxWidth,
                  ),
                  child: RepaintBoundary(
                    key: _shareBoundary,
                    child: BmiResultPanel(
                      state: state,
                      goalWeightKg: goal,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
