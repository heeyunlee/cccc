import 'package:intl/intl.dart';

class Formatter {
  static String currency(num? number, String locale) {
    if (number == null) {
      return '0';
    }

    final f = NumberFormat.simpleCurrency(locale: locale, decimalDigits: 0);

    return f.format(number);
  }

  static String amount(num amount, String locale) {
    final f = NumberFormat.simpleCurrency(name: locale, decimalDigits: 2);

    if (amount < 0) {
      return '+ ${f.format(amount).substring(1)}';
    } else {
      return f.format(amount);
    }
  }
}
