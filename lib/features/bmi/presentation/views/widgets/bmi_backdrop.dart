import 'package:flutter/material.dart';
import 'package:mrmzee_bmi_calculator/design_system/design_system.dart';

/// Warm wash behind the BMI screen.
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
            Positioned(
              top: -140,
              right: -90,
              child: _Wash(color: canvas.glow, diameter: 380),
            ),
            Positioned(
              bottom: -20,
              left: -120,
              child: _Wash(
                color: canvas.brass.withValues(alpha: 0.16),
                diameter: 280,
              ),
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
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
      child: SizedBox.square(dimension: diameter),
    );
  }
}
