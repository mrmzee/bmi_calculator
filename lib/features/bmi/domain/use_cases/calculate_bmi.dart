import 'package:mrmzee_bmi_calculator/features/bmi/domain/entities/bmi.dart';

/// Plain input for [CalculateBmi]. No Flutter or I/O types cross this boundary.
final class CalculateBmiRequest {
  const CalculateBmiRequest({
    required this.weightKg,
    required this.heightMeters,
  });

  final double weightKg;
  final double heightMeters;
}

/// Application action: turn a weight and a height into a [Bmi].
final class CalculateBmi {
  const CalculateBmi();

  Bmi call(CalculateBmiRequest request) {
    final height = request.heightMeters;
    return Bmi(value: request.weightKg / (height * height));
  }
}
