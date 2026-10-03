import 'package:flutter/material.dart';

/// Material 3 motion tokens.
abstract final class AppMotion {
  static const Duration short = Durations.short3;
  static const Duration medium = Durations.medium2;
  static const Duration long = Durations.medium4;

  static const Curve standard = Easing.standard;
  static const Curve decelerate = Easing.emphasizedDecelerate;

  static Duration durationOf(BuildContext context, Duration duration) {
    return MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
  }
}
