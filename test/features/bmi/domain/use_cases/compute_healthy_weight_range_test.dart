import 'package:flutter_test/flutter_test.dart';
import 'package:mrmzee_bmi_calculator/features/bmi/domain/use_cases/compute_healthy_weight_range.dart';

void main() {
  group(ComputeHealthyWeightRange, () {
    const compute = ComputeHealthyWeightRange();

    test('returns WHO normal band weights for the height', () {
      final range = compute(1.75);

      expect(range.minKg, closeTo(56.66, 0.02));
      expect(range.maxKg, closeTo(76.26, 0.02));
      expect(range.contains(70), isTrue);
      expect(range.deltaKg(80), closeTo(3.74, 0.02));
      expect(range.deltaKg(50), closeTo(6.66, 0.02));
    });
  });
}
