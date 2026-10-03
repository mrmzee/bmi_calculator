import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_reading_copy.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/view_models/bmi_view_model.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_layout.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_app_bar.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_page.dart';
import 'package:mrmzee_bmi_calculator/features/profile/domain/entities/profile.dart';
import 'package:mrmzee_bmi_calculator/features/profile/presentation/view_models/profile_view_model.dart';

/// Names the people who use this device and picks the active one.
class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
    required this.viewModel,
    required this.onProfileRemoved,
  });

  final ProfileViewModel viewModel;
  final Future<void> Function(String profileId) onProfileRemoved;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  var _error = '';

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final age = int.tryParse(_ageController.text.trim());
    final saved = await widget.viewModel.add(
      name: _nameController.text,
      age: age ?? -1,
    );
    if (!mounted) {
      return;
    }
    if (!saved) {
      setState(() => _error = invalidProfileInputMessage);
      return;
    }
    _nameController.clear();
    _ageController.clear();
    setState(() => _error = '');
  }

  Future<void> _edit(Profile profile) async {
    final nameController = TextEditingController(text: profile.name);
    final ageController = TextEditingController(
      text: profile.age?.toString() ?? '',
    );
    var error = '';
    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('ویرایش پروفایل'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'نام'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(labelText: 'سن'),
                  ),
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      error,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('انصراف'),
                ),
                FilledButton(
                  onPressed: () async {
                    final age = int.tryParse(ageController.text.trim());
                    final saved = await widget.viewModel.update(
                      id: profile.id,
                      name: nameController.text,
                      age: age ?? -1,
                    );
                    if (!context.mounted) {
                      return;
                    }
                    if (!saved) {
                      setDialogState(() => error = invalidProfileInputMessage);
                      return;
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('ذخیره'),
                ),
              ],
            );
          },
        );
      },
    );
    nameController.dispose();
    ageController.dispose();
  }

  Future<void> _editGoal(Profile profile) async {
    final controller = TextEditingController(
      text: profile.goalWeightKg == null
          ? ''
          : formatKilograms(profile.goalWeightKg!),
    );
    var error = '';
    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('هدف وزن'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                      labelText: 'کیلوگرم',
                    ),
                  ),
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      error,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ],
                ],
              ),
              actions: [
                if (profile.goalWeightKg != null)
                  TextButton(
                    onPressed: () async {
                      await widget.viewModel.setGoalWeight(
                        id: profile.id,
                        kilograms: null,
                      );
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('حذف هدف'),
                  ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('انصراف'),
                ),
                FilledButton(
                  onPressed: () async {
                    final text = controller.text.trim();
                    if (text.isEmpty) {
                      setDialogState(() => error = invalidGoalWeightMessage);
                      return;
                    }
                    final kilograms = parseMeasurementText(text);
                    final saved = await widget.viewModel.setGoalWeight(
                      id: profile.id,
                      kilograms: kilograms,
                    );
                    if (!context.mounted) {
                      return;
                    }
                    if (!saved) {
                      setDialogState(() => error = invalidGoalWeightMessage);
                      return;
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('ذخیره'),
                ),
              ],
            );
          },
        );
      },
    );
    controller.dispose();
  }

  Future<void> _openAddSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              final textTheme = Theme.of(context).textTheme;
              final colorScheme = Theme.of(context).colorScheme;
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('شخص جدید', style: textTheme.titleLarge),
                      const SizedBox(height: AppSpacing.md),
                      TextField(
                        key: const Key('profile-name-field'),
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'نام'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextField(
                        key: const Key('profile-age-field'),
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(labelText: 'سن'),
                        onSubmitted: (_) async {
                          await _add();
                          if (context.mounted && _error.isEmpty) {
                            Navigator.of(context).pop();
                          } else {
                            setSheetState(() {});
                          }
                        },
                      ),
                      if (_error.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          _error,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      FilledButton(
                        key: const Key('add-profile-button'),
                        onPressed: () async {
                          await _add();
                          if (context.mounted && _error.isEmpty) {
                            Navigator.of(context).pop();
                          } else {
                            setSheetState(() {});
                          }
                        },
                        child: const Text('افزودن'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _remove(Profile profile) async {
    final removed = await widget.viewModel.remove(profile.id);
    if (removed == null) {
      return;
    }
    await widget.onProfileRemoved(removed);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final state = widget.viewModel.state;
        return BmiPage(
          header: const BmiAppBar(
            title: 'پروفایل',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Row(
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: context.appCanvas.accent.withValues(
                                  alpha: 0.12,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: SizedBox.square(
                                dimension: AppSpacing.xxlg + AppSpacing.sm,
                                child: Center(
                                  child: Icon(
                                    Icons.groups_outlined,
                                    color: context.appCanvas.accent,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                'سنجش‌ها برای شخص فعال ذخیره می‌شود.',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    for (final profile in state.profiles) ...[
                      _ProfileCard(
                        profile: profile,
                        selected: profile.id == state.activeId,
                        onSelect: () => widget.viewModel.select(profile.id),
                        onEdit: () => _edit(profile),
                        onGoal: () => _editGoal(profile),
                        onRemove: () => _remove(profile),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    FilledButton.icon(
                      onPressed: _openAddSheet,
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text('افزودن شخص'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.profile,
    required this.selected,
    required this.onSelect,
    required this.onEdit,
    required this.onGoal,
    required this.onRemove,
  });

  final Profile profile;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onGoal;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final canvas = context.appCanvas;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: selected
          ? Color.alphaBlend(
              canvas.accent.withValues(alpha: 0.08),
              canvas.panel,
            )
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        side: selected
            ? BorderSide(color: canvas.accent, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? canvas.accent : canvas.hairline,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxs),
                  child: CircleAvatar(
                    backgroundColor: selected ? canvas.accent : canvas.field,
                    foregroundColor: selected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                    child: Text(_initial(profile.name)),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name, style: textTheme.titleMedium),
                    Text(
                      profile.age == null
                          ? 'سن ثبت نشده'
                          : '${toPersianDigits('${profile.age}')} سال',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      profile.goalWeightKg == null
                          ? 'هدف وزن تنظیم نشده'
                          : 'هدف ${formatKilograms(profile.goalWeightKg!)} کیلوگرم',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: canvas.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    child: Text(
                      'فعال',
                      style: textTheme.labelMedium?.copyWith(
                        color: canvas.accent,
                      ),
                    ),
                  ),
                ),
              PopupMenuButton<String>(
                tooltip: 'گزینه‌های پروفایل',
                onSelected: (value) {
                  switch (value) {
                    case 'goal':
                      onGoal();
                    case 'edit':
                      onEdit();
                    case 'delete':
                      onRemove();
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(value: 'goal', child: Text('هدف وزن')),
                    PopupMenuItem(value: 'edit', child: Text('ویرایش')),
                    PopupMenuItem(value: 'delete', child: Text('حذف')),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _initial(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) {
    return '؟';
  }
  return String.fromCharCode(trimmed.runes.first);
}
