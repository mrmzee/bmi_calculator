import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi_history_entry.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_category_message.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/bmi_status.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/presentation/theme/bmi_status_palette.dart';

/// Recent calculations with a smooth trend line.
class BmiHistorySection extends StatelessWidget {
  const BmiHistorySection({
    super.key,
    required this.entries,
    required this.onClear,
  });

  final List<BmiHistoryEntry> entries;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final canvas = context.appCanvas;

    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    final chronological = entries.reversed.toList(growable: false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text('تاریخچه', style: textTheme.titleLarge)),
                TextButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('پاک کردن'),
                ),
              ],
            ),
            if (entries.length > 1) ...[
              const SizedBox(height: AppSpacing.sm),
              Semantics(
                label: 'نمودار روند شاخص توده بدنی',
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: canvas.field,
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: SizedBox(
                      height: 88,
                      child: CustomPaint(
                        painter: _HistoryTrendPainter(
                          values: [
                            for (final entry in chronological) entry.bmiValue,
                          ],
                          lineColor: canvas.brass,
                          fillColor: canvas.brass.withValues(alpha: 0.16),
                          dotColor: canvas.panel,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            for (final (index, entry) in entries.take(8).indexed)
              _HistoryTile(entry: entry, first: index == 0),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry, required this.first});

  final BmiHistoryEntry entry;
  final bool first;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final accent = context.bmiStatusPalette.of(
      bmiStatusOf(Bmi(value: entry.bmiValue)),
    );

    return Padding(
      padding: EdgeInsets.only(top: first ? 0 : AppSpacing.md),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(AppSpacing.radius),
            ),
            child: const SizedBox(width: AppSpacing.xxs, height: 40),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.category.shortLabel, style: textTheme.titleMedium),
                Text(
                  '${entry.weightKg.toStringAsFixed(1)} kg · '
                  '${(entry.heightMeters * 100).round()} cm · '
                  '${_formatDate(entry.recordedAt)}',
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
        ],
      ),
    );
  }
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '${local.year}/$month/$day $hour:$minute';
}

class _HistoryTrendPainter extends CustomPainter {
  const _HistoryTrendPainter({
    required this.values,
    required this.lineColor,
    required this.fillColor,
    required this.dotColor,
  });

  final List<double> values;
  final Color lineColor;
  final Color fillColor;
  final Color dotColor;

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

    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final span = math.max(maxValue - minValue, 1.0);
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
        oldDelegate.dotColor != dotColor;
  }
}
