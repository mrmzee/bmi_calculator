import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';

/// Screen title with optional back, share, and reset actions.
class BmiAppBar extends StatelessWidget {
  const BmiAppBar({
    super.key,
    this.eyebrow = 'تعادل بدن',
    this.title = 'شاخص توده بدنی',
    this.onShare,
    this.onReset,
    this.canShare = false,
    this.leading,
  });

  final String eyebrow;
  final String title;
  final VoidCallback? onShare;
  final VoidCallback? onReset;
  final bool canShare;
  final Widget? leading;

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
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (eyebrow.isNotEmpty) ...[
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: canvas.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLarge,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        child: Text(
                          eyebrow,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelMedium?.copyWith(
                            color: canvas.accent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    title,
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onShare != null)
            _RoundAction(
              buttonKey: const Key('share-button'),
              tooltip: 'اشتراک‌گذاری نتیجه',
              onPressed: canShare ? onShare : null,
              icon: Icons.ios_share_outlined,
            ),
          if (onShare != null && onReset != null)
            const SizedBox(width: AppSpacing.sm),
          if (onReset != null)
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
        foregroundColor: canvas.accent,
        elevation: 2,
        shadowColor: canvas.accent.withValues(alpha: 0.2),
        shape: const CircleBorder(),
      ),
    );
  }
}
