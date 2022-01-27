import 'package:intl/intl.dart';

class Formatter {
  static String currency(num? number, String locale) {
    if (number == null) {
      return '0';
    }

    final f = NumberFormat.simpleCurrency(locale: locale, decimalDigits: 0);

    return f.format(number);
  }
}
