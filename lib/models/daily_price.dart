import 'price_direction.dart';

class DailyPrice {
  const DailyPrice({
    required this.localDate,
    required this.closePrice,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.accumulatedTradingVolume,
    this.previousClosePrice,
  });

  /// Normalized date in `yyyyMMdd` format.
  final String localDate;
  final int closePrice;
  final int openPrice;
  final int highPrice;
  final int lowPrice;
  final int accumulatedTradingVolume;
  final int? previousClosePrice;

  int? get changeAmount {
    final int? previous = previousClosePrice;
    if (previous == null) {
      return null;
    }
    return closePrice - previous;
  }

  double? get changeRate {
    final int? previous = previousClosePrice;
    final int? change = changeAmount;
    if (previous == null || previous == 0 || change == null) {
      return null;
    }
    return change / previous;
  }

  PriceDirection get direction {
    final int? change = changeAmount;
    if (change == null) {
      return PriceDirection.flat;
    }
    return PriceDirection.fromChange(change);
  }
}
