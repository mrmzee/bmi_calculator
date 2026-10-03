import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';

/// Screen title with share and reset actions.
class BmiAppBar extends StatelessWidget {
  const BmiAppBar({
    super.key,
    required this.onShare,
    required this.onReset,
    this.canShare = false,
  });

  final VoidCallback onShare;
  final VoidCallback onReset;
  final bool canShare;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final canvas = context.appCanvas;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تعادل بدن',
                  style: textTheme.labelSmall?.copyWith(color: canvas.brass),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'شاخص توده بدنی',
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _RoundAction(
            buttonKey: const Key('share-button'),
            tooltip: 'اشتراک‌گذاری نتیجه',
            onPressed: canShare ? onShare : null,
            icon: Icons.ios_share_outlined,
          ),
          const SizedBox(width: AppSpacing.sm),
          _RoundAction(
            tooltip: 'شروع دوباره',
            onPressed: onReset,
            icon: Icons.restart_alt_sharp,
          ),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    this.buttonKey,
    required this.tooltip,
    required this.onPressed,
    required this.icon,
  });

  final Key? buttonKey;
  final String tooltip;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final canvas = context.appCanvas;

    return IconButton(
      key: buttonKey,
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        fixedSize: const Size.square(AppSpacing.xxlg + AppSpacing.lg),
        backgroundColor: canvas.panel,
        side: BorderSide(color: canvas.hairline),
        shape: const CircleBorder(),
      ),
    );
  }
}
