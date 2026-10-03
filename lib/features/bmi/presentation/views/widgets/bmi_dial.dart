import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';

/// Thin arc gauge. The status color lives on the arc and its knob.
class BmiDial extends StatelessWidget {
  const BmiDial({
    super.key,
    required this.diameter,
    required this.accent,
    required this.progress,
    required this.child,
    this.showMarkers = true,
  });

  final double diameter;
  final Color accent;
  final double progress;
  final Widget child;
  final bool showMarkers;

  static const sweep = math.pi * 1.5;
  static const _scaleMin = 15.0;
  static const _scaleMax = 40.0;
  static const _markers = [18.5, 25.0, 30.0];

  @override
  Widget build(BuildContext context) {
    final canvas = context.appCanvas;
    final reversed = Directionality.of(context) == TextDirection.rtl;
    final stroke = diameter * 0.035;
    final knob = math.max(stroke * 2.4, 14.0);
    final radius = diameter / 2 - knob;

    return Semantics(
      label: 'نمایشگر شاخص توده بدنی',
      child: SizedBox.square(
        dimension: diameter,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: progress),
          duration: AppMotion.durationOf(context, AppMotion.medium),
          curve: AppMotion.decelerate,
          builder: (context, value, child) {
            final angle = _angleFor(value, reversed: reversed);
            final center = diameter / 2;
            return Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size.square(diameter),
                  painter: _GaugePainter(
                    progress: value,
                    accent: accent,
                    trackColor: canvas.hairline,
                    reversed: reversed,
                    showMarkers: showMarkers,
                    stroke: stroke,
                    radius: radius,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(knob + AppSpacing.md),
                  child: child,
                ),
                Positioned(
                  left: center + radius * math.cos(angle) - knob / 2,
                  top: center + radius * math.sin(angle) - knob / 2,
                  child: AnimatedContainer(
                    key: const Key('bmi-status-indicator'),
                    duration: AppMotion.durationOf(context, AppMotion.short),
                    curve: AppMotion.decelerate,
                    width: knob,
                    height: knob,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: canvas.panel, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.45),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          child: child,
        ),
      ),
    );
  }

  static double _angleFor(double progress, {required bool reversed}) {
    final start = reversed ? math.pi / 4 : math.pi * 0.75;
    final direction = reversed ? -1.0 : 1.0;
    return start + direction * sweep * progress;
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({
    required this.progress,
    required this.accent,
    required this.trackColor,
    required this.reversed,
    required this.showMarkers,
    required this.stroke,
    required this.radius,
  });

  final double progress;
  final Color accent;
  final Color trackColor;
  final bool reversed;
  final bool showMarkers;
  final double stroke;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final start = reversed ? math.pi / 4 : math.pi * 0.75;
    final direction = reversed ? -1.0 : 1.0;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, start, direction * BmiDial.sweep, false, track);

    if (showMarkers) {
      final tick = Paint()
        ..color = trackColor
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      for (final mark in BmiDial._markers) {
        final t = ((mark - BmiDial._scaleMin) /
                (BmiDial._scaleMax - BmiDial._scaleMin))
            .clamp(0.0, 1.0);
        final angle = start + direction * BmiDial.sweep * t;
        canvas.drawLine(
          _point(center, radius - stroke, angle),
          _point(center, radius + stroke * 0.2, angle),
          tick,
        );
      }
    }

    if (progress <= 0) {
      return;
    }
    final glow = Paint()
      ..color = accent.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke * 2.6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawArc(
      rect,
      start,
      direction * BmiDial.sweep * progress,
      false,
      glow,
    );
    final arc = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      start,
      direction * BmiDial.sweep * progress,
      false,
      arc,
    );
  }

  Offset _point(Offset center, double radius, double angle) {
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.accent != accent ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.reversed != reversed ||
        oldDelegate.showMarkers != showMarkers;
  }
}
