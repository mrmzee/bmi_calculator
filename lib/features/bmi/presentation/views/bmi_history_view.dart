import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_history_entry.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_layout.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_view_model.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_app_bar.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_history_section.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_page.dart';
import 'package:mrmzee_bmi_calculator/features/profile/presentation/view_models/profile_view_model.dart';

/// Trend and saved calculations for the active profile.
class BmiHistoryView extends StatelessWidget {
  const BmiHistoryView({
    super.key,
    required this.viewModel,
    required this.profiles,
  });

  final BmiViewModel viewModel;
  final ProfileViewModel profiles;

  List<BmiHistoryEntry> _entries() {
    final activeId = profiles.state.active?.id;
    if (activeId == null) {
      return const [];
    }
    return [
      for (final entry in viewModel.state.history)
        if (entry.profileId == activeId) entry,
    ];
  }

  Future<void> _clear(BuildContext context) async {
    final active = profiles.state.active;
    if (active == null) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('پاک کردن تاریخچه'),
          content: Text(
            'محاسبه‌های ${active.name} حذف می‌شوند. '
            'ادامه می‌دهید؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('انصراف'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('پاک کردن'),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      await viewModel.clearHistoryFor(active.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([viewModel, profiles]),
      builder: (context, _) {
        final name = profiles.state.active?.name ?? '';
        final entries = _entries();
        return BmiPage(
          header: BmiAppBar(
            eyebrow: name,
            title: 'تاریخچه',
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
                child: entries.isEmpty
                    ? _EmptyHistory(name: name)
                    : BmiHistorySection(
                        entries: entries,
                        onClear: () => _clear(context),
                        onSelect: (entry) =>
                            context.push('/results/${entry.id}'),
                        onDelete: (id) {
                          viewModel.deleteHistoryEntry(id);
                        },
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final canvas = context.appCanvas;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xlg),
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    canvas.glow,
                    canvas.field,
                  ],
                ),
              ),
              child: SizedBox.square(
                dimension: AppSpacing.xxlg + AppSpacing.xlg,
                child: Center(
                  child: Icon(
                    Icons.show_chart_outlined,
                    color: canvas.accent,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'هنوز سنجشی برای $name ثبت نشده.',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
