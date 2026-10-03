/// WHO adult BMI classification bands used by this app.
///
/// Bounds are inclusive at the lower edge of each band, except the lowest
/// band which has no lower bound.
enum BmiCategory {
  severeThinness,
  moderateThinness,
  mildThinness,
  normal,
  overweight,
  obeseClass1,
  obeseClass2,
  obeseClass3,
}
