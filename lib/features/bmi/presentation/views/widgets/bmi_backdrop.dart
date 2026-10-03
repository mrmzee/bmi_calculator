import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';

/// Soft layered wash behind every screen.
class BmiBackdrop extends StatelessWidget {
  const BmiBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    final canvas = context.appCanvas;

    return IgnorePointer(
      child: ColoredBox(
        color: canvas.canvas,
        child: Stack(
          children: [
            PositionedDirectional(
              top: -200,
              start: -90,
              child: _Wash(color: canvas.glow, diameter: 440),
            ),
            PositionedDirectional(
              top: 80,
              end: -140,
              child: _Wash(color: canvas.glowAlt, diameter: 280),
            ),
            PositionedDirectional(
              bottom: -80,
              start: -40,
              child: _Wash(color: canvas.glow, diameter: 260),
            ),
          ],
        ),
      ),
    );
  }
}

class _Wash extends StatelessWidget {
  const _Wash({required this.color, required this.diameter});

  final Color color;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.95), color.withValues(alpha: 0)],
        ),
      ),
      child: SizedBox.square(dimension: diameter),
    );
  }
}
