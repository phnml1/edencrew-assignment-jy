String formatNumber(num value) {
  final String raw = value.round().abs().toString();
  final StringBuffer buffer = StringBuffer();

  for (int index = 0; index < raw.length; index += 1) {
    final int remaining = raw.length - index;
    buffer.write(raw[index]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }

  final String formatted = buffer.toString();
  return value < 0 ? '-$formatted' : formatted;
}

String formatSignedNumber(num value) {
  if (value > 0) {
    return '+${formatNumber(value)}';
  }
  return formatNumber(value);
}

String formatPercent(double value, {bool signed = true}) {
  final double percent = value * 100;
  final String sign = signed && percent > 0 ? '+' : '';
  return '$sign${percent.toStringAsFixed(2)}%';
}

String formatPriceChange(int changeAmount, double changeRate) {
  return '${formatSignedNumber(changeAmount)} (${formatPercent(changeRate)})';
}

String formatCompactVolume(int volume) {
  if (volume >= 1000) {
    return '${formatNumber(volume / 1000)}천';
  }
  return formatNumber(volume);
}

String formatMarketCap(int marketCap) {
  const int eok = 100000000;
  const int jo = 1000000000000;

  if (marketCap >= jo) {
    return '${formatNumber(marketCap / jo)}조';
  }
  if (marketCap >= eok) {
    return '${formatNumber(marketCap / eok)}억';
  }
  return formatNumber(marketCap);
}

String formatDateAsMonthDay(String localDate) {
  final RegExp naverDatePattern = RegExp(r'^\d{8}$');
  if (!naverDatePattern.hasMatch(localDate)) {
    return localDate;
  }
  return '${localDate.substring(4, 6)}.${localDate.substring(6, 8)}';
}
