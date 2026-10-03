import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_category_message.dart';

/// Category sentence, a validation sentence, or the empty-state hint.
class BmiMessageText extends StatelessWidget {
  const BmiMessageText({
    super.key,
    required this.message,
    this.color,
  });

  final String message;
  final Color? color;

  static const _validationMessages = {
    incompleteInputMessage,
    notNumericInputMessage,
    weightOutOfRangeMessage,
    heightOutOfRangeMessage,
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ink = color ?? colorScheme.onSurface;
    if (message.isEmpty) {
      return Text(
        'وزن و قد را وارد کنید',
        textAlign: TextAlign.center,
        style: textTheme.bodyLarge?.copyWith(
          color: ink.withValues(alpha: 0.72),
        ),
      );
    }

    final isError = _validationMessages.contains(message);
    if (!isError) {
      return Text(
        message,
        textAlign: TextAlign.center,
        style: textTheme.titleMedium?.copyWith(color: ink, height: 1.5),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.error_outline,
              size: 20,
              color: colorScheme.onErrorContainer,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
