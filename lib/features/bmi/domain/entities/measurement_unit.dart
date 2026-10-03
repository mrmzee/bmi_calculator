/// Display and input units for body measurements.
enum WeightUnit { kilogram, pound }

enum HeightUnit { centimeter, meter }

/// Converts between metric storage and the unit shown in the form.
abstract final class MeasurementConverter {
  static const poundsPerKilogram = 2.2046226218;

  static double kilogramsFrom(double value, WeightUnit unit) {
    return switch (unit) {
      WeightUnit.kilogram => value,
      WeightUnit.pound => value / poundsPerKilogram,
    };
  }

  static double displayWeight(double kilograms, WeightUnit unit) {
    return switch (unit) {
      WeightUnit.kilogram => kilograms,
      WeightUnit.pound => kilograms * poundsPerKilogram,
    };
  }

  static double metersFrom(double value, HeightUnit unit) {
    return switch (unit) {
      HeightUnit.meter => value,
      HeightUnit.centimeter => value / 100,
    };
  }

  static double displayHeight(double meters, HeightUnit unit) {
    return switch (unit) {
      HeightUnit.meter => meters,
      HeightUnit.centimeter => meters * 100,
    };
  }

  static String weightSuffix(WeightUnit unit) {
    return switch (unit) {
      WeightUnit.kilogram => 'kg',
      WeightUnit.pound => 'lb',
    };
  }

  static String heightSuffix(HeightUnit unit) {
    return switch (unit) {
      HeightUnit.centimeter => 'cm',
      HeightUnit.meter => 'm',
    };
  }
}
