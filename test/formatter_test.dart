import 'package:cccc/styles/formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('currency', () {
    test('positive', () {
      final a = Formatter.currency(120, 'en_US');

      expect(a, '\$120');
    });

    test('zero', () {
      final a = Formatter.currency(0, 'en_US');

      expect(a, '\$0');
    });

    test('negative', () {
      final a = Formatter.currency(-10, 'en_US');

      expect(a, '-\$10');
    });

    test('null', () {
      final a = Formatter.currency(null, 'en_US');

      expect(a, '0');
    });
  });
}
