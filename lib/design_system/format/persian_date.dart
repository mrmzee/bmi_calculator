/// A year, month, and day in the Jalali calendar.
final class JalaliDate {
  const JalaliDate({
    required this.year,
    required this.month,
    required this.day,
  });

  final int year;
  final int month;
  final int day;
}

const persianMonths = [
  'فروردین',
  'اردیبهشت',
  'خرداد',
  'تیر',
  'مرداد',
  'شهریور',
  'مهر',
  'آبان',
  'آذر',
  'دی',
  'بهمن',
  'اسفند',
];

const _persianDigits = '۰۱۲۳۴۵۶۷۸۹';

/// Replaces Western digits with Persian digits.
String toPersianDigits(String input) {
  final buffer = StringBuffer();
  for (final codeUnit in input.runes) {
    final character = String.fromCharCode(codeUnit);
    final digit = int.tryParse(character);
    buffer.write(digit == null ? character : _persianDigits[digit]);
  }
  return buffer.toString();
}

/// Converts a Gregorian civil date to the Jalali calendar.
///
/// The arithmetic follows the well-known 33-year Jalali cycle used by the
/// `jalaali` algorithm.
JalaliDate gregorianToJalali(int year, int month, int day) {
  final monthDays = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
  final leapYear = month > 2 ? year + 1 : year;
  var days = 355666 +
      (365 * year) +
      ((leapYear + 3) ~/ 4) -
      ((leapYear + 99) ~/ 100) +
      ((leapYear + 399) ~/ 400) +
      day +
      monthDays[month - 1];
  var jalaliYear = -1595 + (33 * (days ~/ 12053));
  days %= 12053;
  jalaliYear += 4 * (days ~/ 1461);
  days %= 1461;
  if (days > 365) {
    jalaliYear += (days - 1) ~/ 365;
    days = (days - 1) % 365;
  }
  final jalaliMonth = days < 186 ? 1 + (days ~/ 31) : 7 + ((days - 186) ~/ 30);
  final jalaliDay = 1 + (days < 186 ? (days % 31) : ((days - 186) % 30));
  return JalaliDate(year: jalaliYear, month: jalaliMonth, day: jalaliDay);
}

/// Persian calendar date without a clock, such as `۱۱ مهر ۱۴۰۵`.
String formatJalaliDate(DateTime date) {
  final local = date.toLocal();
  final jalali = gregorianToJalali(local.year, local.month, local.day);
  final monthName = persianMonths[jalali.month - 1];
  return '${toPersianDigits('${jalali.day}')} '
      '$monthName '
      '${toPersianDigits('${jalali.year}')}';
}
