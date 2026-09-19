import 'package:edencrew_assignment_starter/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('stock formatters', () {
    test('formats comma separated numbers', () {
      expect(formatNumber(0), '0');
      expect(formatNumber(1234), '1,234');
      expect(formatNumber(-1234567), '-1,234,567');
    });

    test('formats signed price changes', () {
      expect(formatSignedNumber(400), '+400');
      expect(formatSignedNumber(-400), '-400');
      expect(formatSignedNumber(0), '0');
    });

    test('formats percent values from rates', () {
      expect(formatPercent(0.01234), '+1.23%');
      expect(formatPercent(-0.0022), '-0.22%');
      expect(formatPercent(0), '0.00%');
    });

    test('formats price change with rate', () {
      expect(formatPriceChange(-400, -0.0022), '-400 (-0.22%)');
    });

    test('formats compact volume and market cap', () {
      expect(formatCompactVolume(29113000), '29,113천');
      expect(formatMarketCap(1063000000000000), '1,063조');
    });

    test('formats Naver daily date as MM.DD', () {
      expect(formatDateAsMonthDay('20260919'), '09.19');
      expect(formatDateAsMonthDay('bad-date'), 'bad-date');
    });
  });
}
