import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_layout.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_app_bar.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/views/widgets/bmi_page.dart';
import 'package:mrmzee_bmi_calculator/features/profile/presentation/view_models/profile_view_model.dart';

/// First screen. The shell stays hidden until a name and age are saved.
class ProfileSetupView extends StatefulWidget {
  const ProfileSetupView({super.key, required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  State<ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<ProfileSetupView> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  var _error = '';
  var _prefilled = false;

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_prefill);
    _prefill();
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_prefill);
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _prefill() {
    if (_prefilled || !widget.viewModel.state.isLoaded) {
      return;
    }
    final active = widget.viewModel.state.active;
    if (active != null && !active.isComplete && _nameController.text.isEmpty) {
      _nameController.text = active.name;
    }
    _prefilled = true;
  }

  Future<void> _submit() async {
    final age = int.tryParse(_ageController.text.trim());
    final active = widget.viewModel.state.active;
    final completing = active != null && !active.isComplete;
    final saved = completing
        ? await widget.viewModel.update(
            id: active.id,
            name: _nameController.text,
            age: age ?? -1,
          )
        : await widget.viewModel.add(
            name: _nameController.text,
            age: age ?? -1,
          );
    if (!mounted) {
      return;
    }
    setState(() {
      _error = saved ? '' : invalidProfileInputMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: context.appCanvas.canvas,
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          final state = widget.viewModel.state;
          final completing = state.active != null && !state.active!.isComplete;
          return BmiPage(
            includeBottomInset: true,
            header: BmiAppBar(
              eyebrow: 'شروع',
              title: completing ? 'تکمیل پروفایل' : 'ساخت پروفایل',
            ),
            body: state.isLoaded
                ? SingleChildScrollView(
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
                            const _SetupMark(),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'نام و سن برای تفسیر نتیجه و جدا کردن '
                              'تاریخچه هر نفر کافی است.',
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    TextField(
                                      key: const Key('profile-setup-name'),
                                      controller: _nameController,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        labelText: 'نام',
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    TextField(
                                      key: const Key('profile-setup-age'),
                                      controller: _ageController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      textInputAction: TextInputAction.done,
                                      decoration: const InputDecoration(
                                        labelText: 'سن',
                                      ),
                                      onSubmitted: (_) => _submit(),
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
                                    const SizedBox(height: AppSpacing.lg),
                                    FilledButton(
                                      key: const Key('profile-setup-save'),
                                      onPressed: _submit,
                                      child: Text(
                                        completing ? 'ذخیره' : 'ساختن پروفایل',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class _SetupMark extends StatelessWidget {
  const _SetupMark();

  @override
  Widget build(BuildContext context) {
    final canvas = context.appCanvas;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              canvas.glow,
              canvas.glow.withValues(alpha: 0),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: canvas.panel,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: canvas.accent.withValues(alpha: 0.16),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SizedBox.square(
              dimension: AppSpacing.xxlg + AppSpacing.xlg,
              child: Center(
                child: Icon(
                  Icons.person_add_alt_1,
                  color: canvas.accent,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
