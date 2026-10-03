import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_history_entry.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_category_message.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_reading_copy.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_status.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_status_palette.dart';

/// Recent calculations with a smooth trend line.
class BmiHistorySection extends StatelessWidget {
  const BmiHistorySection({
    super.key,
    required this.entries,
    required this.onClear,
    this.onSelect,
    this.onDelete,
  });

  final List<BmiHistoryEntry> entries;
  final VoidCallback onClear;
  final ValueChanged<BmiHistoryEntry>? onSelect;
  final ValueChanged<String>? onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final canvas = context.appCanvas;

    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    final chronological = entries.reversed.toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text('سنجش‌ها', style: textTheme.titleLarge)),
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('پاک کردن'),
            ),
          ],
        ),
        if (entries.length > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Semantics(
              label: 'نمودار روند شاخص توده بدنی',
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 120,
                      child: CustomPaint(
                        painter: _HistoryTrendPainter(
                          values: [
                            for (final entry in chronological) entry.bmiValue,
                          ],
                          lineColor: canvas.accent,
                          fillColor: canvas.accent.withValues(alpha: 0.16),
                          bandColor: context.bmiStatusPalette.normal
                              .withValues(alpha: 0.18),
                          dotColor: canvas.panel,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'نوار رنگی، بازه شاخص ۱۸٫۵ تا ۲۵ است.',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        for (final (index, entry) in entries.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.sm),
          _HistoryTile(
            entry: entry,
            previous: index + 1 < entries.length ? entries[index + 1] : null,
            onSelect: onSelect == null ? null : () => onSelect!(entry),
            onDelete: onDelete == null ? null : () => onDelete!(entry.id),
          ),
        ],
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.entry,
    this.previous,
    this.onSelect,
    this.onDelete,
  });

  final BmiHistoryEntry entry;
  final BmiHistoryEntry? previous;
  final VoidCallback? onSelect;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final accent = context.bmiStatusPalette.of(
      entry.isYouth ? BmiStatus.youth : bmiStatusOf(Bmi(value: entry.bmiValue)),
    );

    final delta = previous == null
        ? null
        : bmiDeltaLabel(
            current: entry.bmiValue,
            previous: previous!.bmiValue,
          );
    final tile = Card(
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
                  color: accent.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: SizedBox.square(
                  dimension: AppSpacing.xxlg + AppSpacing.sm,
                  child: Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                      child: const SizedBox.square(dimension: AppSpacing.md),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.isYouth
                          ? youthResultLabel
                          : entry.category.shortLabel,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      '${measurementLine(entry)} · '
                      '${formatJalaliDate(entry.recordedAt)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (delta != null)
                      Text(
                        delta,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                entry.bmiValue.toStringAsFixed(1),
                textDirection: TextDirection.ltr,
                style: textTheme.titleLarge?.copyWith(color: accent),
              ),
              if (onDelete != null)
                PopupMenuButton<String>(
                  tooltip: 'گزینه‌های سنجش',
                  onSelected: (_) => onDelete!(),
                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem(value: 'delete', child: Text('حذف')),
                    ];
                  },
                ),
            ],
          ),
        ),
      ),
    );

    if (onDelete == null) {
      return tile;
    }

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.horizontal,
      onDismissed: (_) => onDelete!(),
      background: const _DeleteBackground(),
      secondaryBackground: const _DeleteBackground(),
      child: tile,
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child:
              Icon(Icons.delete_outline, color: colorScheme.onErrorContainer),
        ),
      ),
    );
  }
}

class _HistoryTrendPainter extends CustomPainter {
  const _HistoryTrendPainter({
    required this.values,
    required this.lineColor,
    required this.fillColor,
    required this.bandColor,
    required this.dotColor,
  });

  final List<double> values;
  final Color lineColor;
  final Color fillColor;
  final Color bandColor;
  final Color dotColor;

  static const _bandLow = 18.5;
  static const _bandHigh = 25.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }
    if (values.length == 1) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        4,
        Paint()..color = lineColor,
      );
      return;
    }

    final minValue = math.min(values.reduce(math.min), _bandLow);
    final maxValue = math.max(values.reduce(math.max), _bandHigh);
    final span = math.max(maxValue - minValue, 1.0);
    final bandTop = size.height -
        (((_bandHigh - minValue) / span) * (size.height - 12) + 6);
    final bandBottom =
        size.height - (((_bandLow - minValue) / span) * (size.height - 12) + 6);
    canvas.drawRect(
      Rect.fromLTRB(0, bandTop, size.width, bandBottom),
      Paint()..color = bandColor,
    );
    final dx = size.width / (values.length - 1);

    Offset pointAt(int index) {
      final normalized = (values[index] - minValue) / span;
      final y = size.height - (normalized * (size.height - 12) + 6);
      return Offset(dx * index, y);
    }

    final points = [for (var i = 0; i < values.length; i++) pointAt(i)];
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final controlX = (current.dx + next.dx) / 2;
      path.cubicTo(controlX, current.dy, controlX, next.dy, next.dx, next.dy);
    }

    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fill, Paint()..color = fillColor);
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final dotFill = Paint()..color = lineColor;
    final dotStroke = Paint()
      ..color = dotColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final point in points) {
      canvas.drawCircle(point, 4, dotFill);
      canvas.drawCircle(point, 4, dotStroke);
    }
  }

  @override
  bool shouldRepaint(_HistoryTrendPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.bandColor != bandColor ||
        oldDelegate.dotColor != dotColor;
  }
}
