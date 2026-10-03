import 'package:flutter_test/flutter_test.dart';
import 'package:mrmzee_bmi_calculator/design_system/format/persian_date.dart';

void main() {
  group('gregorianToJalali', () {
    test('maps 11 February 1979 to 22 Bahman 1357', () {
      final jalali = gregorianToJalali(1979, 2, 11);

      expect(jalali.year, 1357);
      expect(jalali.month, 11);
      expect(jalali.day, 22);
    });

    test('maps 20 March 2024 to 1 Farvardin 1403', () {
      final jalali = gregorianToJalali(2024, 3, 20);

      expect(jalali.year, 1403);
      expect(jalali.month, 1);
      expect(jalali.day, 1);
    });
  });

  group('formatJalaliDate', () {
    test('writes the day, month name, and year in Persian digits', () {
      expect(
        formatJalaliDate(DateTime(2024, 3, 20)),
        '۱ فروردین ۱۴۰۳',
      );
    });
  });
}
