import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';

/// Status ring with a watch-style progress mark.
class BmiDial extends StatelessWidget {
  const BmiDial({
    super.key,
    required this.diameter,
    required this.accent,
    required this.progress,
    required this.child,
  });

  final double diameter;
  final Color accent;
  final double progress;
  final Widget child;

  static const _ringFactor = 0.105;

  @override
  Widget build(BuildContext context) {
    final canvas = context.appCanvas;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final ring = diameter * _ringFactor;

    return SizedBox.square(
      dimension: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            key: const Key('bmi-status-indicator'),
            duration: AppMotion.durationOf(context, AppMotion.medium),
            curve: AppMotion.decelerate,
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent,
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.32),
                  blurRadius: 36,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ring),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: canvas.panel,
              ),
              child: Center(child: child),
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(end: progress),
            duration: AppMotion.durationOf(context, AppMotion.medium),
            curve: AppMotion.decelerate,
            builder: (context, value, _) {
              return CustomPaint(
                size: Size.square(diameter),
                painter: _DialPainter(
                  progress: value,
                  markColor: canvas.panel,
                  reversed: rtl,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  const _DialPainter({
    required this.progress,
    required this.markColor,
    required this.reversed,
  });

  final double progress;
  final Color markColor;
  final bool reversed;

  static const _sweep = math.pi * 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final stroke = size.width * 0.045;
    final radius = size.width / 2 - stroke * 1.35;
    final start = reversed ? math.pi / 4 : math.pi * 0.75;
    final direction = reversed ? -1.0 : 1.0;

    final tickPaint = Paint()
      ..color = markColor.withValues(alpha: 0.55)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    const ticks = 32;
    for (var i = 0; i <= ticks; i++) {
      final angle = start + direction * _sweep * (i / ticks);
      final outer = radius + stroke * 0.15;
      final inner = radius - stroke * (i % 8 == 0 ? 1.15 : 0.45);
      canvas.drawLine(
        _point(center, outer, angle),
        _point(center, inner, angle),
        tickPaint,
      );
    }

    if (progress <= 0) {
      return;
    }

    final arcPaint = Paint()
      ..color = markColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      direction * _sweep * progress,
      false,
      arcPaint,
    );
    canvas.drawCircle(
      _point(center, radius, start + direction * _sweep * progress),
      stroke * 0.85,
      Paint()..color = markColor,
    );
  }

  Offset _point(Offset center, double radius, double angle) {
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
  }

  @override
  bool shouldRepaint(_DialPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.markColor != markColor ||
        oldDelegate.reversed != reversed;
  }
}
