import '../models/models.dart';

const List<Stock> sampleStocks = <Stock>[
  Stock(symbol: '005930', name: '삼성전자', market: '코스피'),
  Stock(symbol: '005935', name: '삼성전자우', market: '코스피'),
  Stock(symbol: '207940', name: '삼성바이오로직스', market: '코스피'),
  Stock(symbol: '018260', name: '삼성에스디에스', market: '코스피'),
  Stock(symbol: '010140', name: '삼성중공업', market: '코스피'),
  Stock(symbol: '028260', name: '삼성물산', market: '코스피'),
  Stock(symbol: '000660', name: 'SK하이닉스', market: '코스피'),
  Stock(symbol: '035720', name: '카카오', market: '코스피'),
  Stock(symbol: '247540', name: '에코프로비엠', market: '코스닥'),
  Stock(symbol: '373220', name: 'LG에너지솔루션', market: '코스피'),
];

StockDetail sampleStockDetailFor(Stock stock) {
  final Stock canonicalStock = sampleStocks.firstWhere(
    (Stock item) => item.symbol == stock.symbol,
    orElse: () => stock,
  );
  final StockQuote quote = sampleQuoteFor(canonicalStock);

  if (canonicalStock.symbol == '005930') {
    return StockDetail(
      stock: canonicalStock,
      quote: quote,
      dailyPrices: samsungDailyPrices,
    );
  }

  return StockDetail(
    stock: canonicalStock,
    quote: quote,
    dailyPrices: _dailyPricesForQuote(quote),
  );
}

StockQuote sampleQuoteFor(Stock stock) {
  return switch (stock.symbol) {
    '005930' => const StockQuote(
      symbol: '005930',
      currentPrice: 179700,
      previousClose: 180100,
      openPrice: 172100,
      highPrice: 181700,
      lowPrice: 172000,
      accumulatedTradingVolume: 29113466,
      listedStockCount: 5915000000,
    ),
    '000660' => const StockQuote(
      symbol: '000660',
      currentPrice: 412500,
      previousClose: 403000,
      openPrice: 405000,
      highPrice: 415500,
      lowPrice: 402000,
      accumulatedTradingVolume: 7240000,
      listedStockCount: 728002365,
    ),
    '035720' => const StockQuote(
      symbol: '035720',
      currentPrice: 61300,
      previousClose: 62100,
      openPrice: 62000,
      highPrice: 62600,
      lowPrice: 61000,
      accumulatedTradingVolume: 1395000,
      listedStockCount: 443586406,
    ),
    '247540' => const StockQuote(
      symbol: '247540',
      currentPrice: 195400,
      previousClose: 195400,
      openPrice: 195000,
      highPrice: 198000,
      lowPrice: 193200,
      accumulatedTradingVolume: 614000,
      listedStockCount: 97801344,
    ),
    '373220' => const StockQuote(
      symbol: '373220',
      currentPrice: 379000,
      previousClose: 379000,
      openPrice: 376500,
      highPrice: 382000,
      lowPrice: 374000,
      accumulatedTradingVolume: 518000,
      listedStockCount: 234000000,
    ),
    _ => StockQuote(
      symbol: stock.symbol,
      currentPrice: 100000,
      previousClose: 99500,
      openPrice: 99200,
      highPrice: 101300,
      lowPrice: 98800,
      accumulatedTradingVolume: 850000,
      listedStockCount: 100000000,
    ),
  };
}

final List<DailyPrice> samsungDailyPrices = <DailyPrice>[
  DailyPrice(
    localDate: '20260327',
    closePrice: 179700,
    openPrice: 172100,
    highPrice: 181700,
    lowPrice: 172000,
    accumulatedTradingVolume: 29113466,
    previousClosePrice: 180100,
  ),
  DailyPrice(
    localDate: '20260326',
    closePrice: 180100,
    openPrice: 178700,
    highPrice: 181400,
    lowPrice: 177600,
    accumulatedTradingVolume: 32074131,
    previousClosePrice: 178900,
  ),
  DailyPrice(
    localDate: '20260325',
    closePrice: 178900,
    openPrice: 177900,
    highPrice: 180300,
    lowPrice: 176800,
    accumulatedTradingVolume: 27441209,
    previousClosePrice: 178000,
  ),
  DailyPrice(
    localDate: '20260324',
    closePrice: 178000,
    openPrice: 178000,
    highPrice: 179200,
    lowPrice: 176500,
    accumulatedTradingVolume: 31882540,
    previousClosePrice: 178000,
  ),
  DailyPrice(
    localDate: '20260323',
    closePrice: 178000,
    openPrice: 177800,
    highPrice: 179000,
    lowPrice: 176900,
    accumulatedTradingVolume: 29780397,
    previousClosePrice: 178000,
  ),
  ..._olderSamsungDailyPrices,
  ..._generateOlderDailyPrices(
    startDate: DateTime(2026, 2, 6),
    count: 205,
    baseClosePrice: 166100,
    baseVolume: 23120000,
  ),
];

const List<DailyPrice> _olderSamsungDailyPrices = <DailyPrice>[
  DailyPrice(
    localDate: '20260320',
    closePrice: 177200,
    openPrice: 178000,
    highPrice: 178400,
    lowPrice: 176500,
    accumulatedTradingVolume: 24410000,
    previousClosePrice: 178000,
  ),
  DailyPrice(
    localDate: '20260319',
    closePrice: 178000,
    openPrice: 176900,
    highPrice: 178800,
    lowPrice: 176100,
    accumulatedTradingVolume: 22750000,
    previousClosePrice: 176800,
  ),
  DailyPrice(
    localDate: '20260318',
    closePrice: 176800,
    openPrice: 177200,
    highPrice: 178000,
    lowPrice: 176000,
    accumulatedTradingVolume: 20810000,
    previousClosePrice: 177200,
  ),
  DailyPrice(
    localDate: '20260317',
    closePrice: 177200,
    openPrice: 176800,
    highPrice: 177900,
    lowPrice: 176200,
    accumulatedTradingVolume: 19240000,
    previousClosePrice: 176800,
  ),
  DailyPrice(
    localDate: '20260316',
    closePrice: 176800,
    openPrice: 177100,
    highPrice: 177800,
    lowPrice: 176100,
    accumulatedTradingVolume: 18310000,
    previousClosePrice: 177100,
  ),
  DailyPrice(
    localDate: '20260313',
    closePrice: 177100,
    openPrice: 176300,
    highPrice: 177900,
    lowPrice: 175900,
    accumulatedTradingVolume: 21350000,
    previousClosePrice: 176300,
  ),
  DailyPrice(
    localDate: '20260312',
    closePrice: 176300,
    openPrice: 175900,
    highPrice: 177100,
    lowPrice: 175200,
    accumulatedTradingVolume: 22420000,
    previousClosePrice: 175900,
  ),
  DailyPrice(
    localDate: '20260311',
    closePrice: 175900,
    openPrice: 175700,
    highPrice: 176600,
    lowPrice: 175100,
    accumulatedTradingVolume: 20110000,
    previousClosePrice: 175700,
  ),
  DailyPrice(
    localDate: '20260310',
    closePrice: 175700,
    openPrice: 176200,
    highPrice: 176600,
    lowPrice: 174900,
    accumulatedTradingVolume: 19870000,
    previousClosePrice: 176200,
  ),
  DailyPrice(
    localDate: '20260309',
    closePrice: 176200,
    openPrice: 175100,
    highPrice: 176900,
    lowPrice: 174600,
    accumulatedTradingVolume: 23450000,
    previousClosePrice: 175100,
  ),
  DailyPrice(
    localDate: '20260306',
    closePrice: 175100,
    openPrice: 174900,
    highPrice: 175900,
    lowPrice: 174300,
    accumulatedTradingVolume: 18760000,
    previousClosePrice: 174900,
  ),
  DailyPrice(
    localDate: '20260305',
    closePrice: 174900,
    openPrice: 173800,
    highPrice: 175400,
    lowPrice: 173500,
    accumulatedTradingVolume: 22140000,
    previousClosePrice: 173800,
  ),
  DailyPrice(
    localDate: '20260304',
    closePrice: 173800,
    openPrice: 172900,
    highPrice: 174400,
    lowPrice: 172300,
    accumulatedTradingVolume: 21880000,
    previousClosePrice: 172900,
  ),
  DailyPrice(
    localDate: '20260303',
    closePrice: 172900,
    openPrice: 171800,
    highPrice: 173200,
    lowPrice: 171200,
    accumulatedTradingVolume: 24120000,
    previousClosePrice: 171800,
  ),
  DailyPrice(
    localDate: '20260302',
    closePrice: 171800,
    openPrice: 170900,
    highPrice: 172400,
    lowPrice: 170100,
    accumulatedTradingVolume: 25330000,
    previousClosePrice: 170900,
  ),
  DailyPrice(
    localDate: '20260227',
    closePrice: 170900,
    openPrice: 170200,
    highPrice: 171500,
    lowPrice: 169800,
    accumulatedTradingVolume: 21220000,
    previousClosePrice: 170200,
  ),
  DailyPrice(
    localDate: '20260226',
    closePrice: 170200,
    openPrice: 169500,
    highPrice: 170900,
    lowPrice: 168900,
    accumulatedTradingVolume: 20670000,
    previousClosePrice: 169500,
  ),
  DailyPrice(
    localDate: '20260225',
    closePrice: 169500,
    openPrice: 168600,
    highPrice: 170300,
    lowPrice: 168100,
    accumulatedTradingVolume: 23400000,
    previousClosePrice: 168600,
  ),
  DailyPrice(
    localDate: '20260224',
    closePrice: 168600,
    openPrice: 169100,
    highPrice: 169800,
    lowPrice: 168000,
    accumulatedTradingVolume: 19780000,
    previousClosePrice: 169100,
  ),
  DailyPrice(
    localDate: '20260223',
    closePrice: 169100,
    openPrice: 168800,
    highPrice: 169700,
    lowPrice: 168100,
    accumulatedTradingVolume: 18790000,
    previousClosePrice: 168800,
  ),
  DailyPrice(
    localDate: '20260220',
    closePrice: 168800,
    openPrice: 169200,
    highPrice: 169900,
    lowPrice: 168200,
    accumulatedTradingVolume: 19990000,
    previousClosePrice: 169200,
  ),
  DailyPrice(
    localDate: '20260219',
    closePrice: 169200,
    openPrice: 168000,
    highPrice: 169700,
    lowPrice: 167400,
    accumulatedTradingVolume: 21470000,
    previousClosePrice: 168000,
  ),
  DailyPrice(
    localDate: '20260218',
    closePrice: 168000,
    openPrice: 167900,
    highPrice: 168900,
    lowPrice: 167200,
    accumulatedTradingVolume: 18560000,
    previousClosePrice: 167900,
  ),
  DailyPrice(
    localDate: '20260217',
    closePrice: 167900,
    openPrice: 167000,
    highPrice: 168500,
    lowPrice: 166300,
    accumulatedTradingVolume: 20760000,
    previousClosePrice: 167000,
  ),
  DailyPrice(
    localDate: '20260216',
    closePrice: 167000,
    openPrice: 166300,
    highPrice: 167800,
    lowPrice: 165900,
    accumulatedTradingVolume: 22910000,
    previousClosePrice: 166300,
  ),
  DailyPrice(
    localDate: '20260213',
    closePrice: 166300,
    openPrice: 166900,
    highPrice: 167300,
    lowPrice: 165800,
    accumulatedTradingVolume: 19540000,
    previousClosePrice: 166900,
  ),
  DailyPrice(
    localDate: '20260212',
    closePrice: 166900,
    openPrice: 166500,
    highPrice: 167600,
    lowPrice: 166000,
    accumulatedTradingVolume: 18850000,
    previousClosePrice: 166500,
  ),
  DailyPrice(
    localDate: '20260211',
    closePrice: 166500,
    openPrice: 165700,
    highPrice: 167000,
    lowPrice: 165100,
    accumulatedTradingVolume: 21620000,
    previousClosePrice: 165700,
  ),
  DailyPrice(
    localDate: '20260210',
    closePrice: 165700,
    openPrice: 166100,
    highPrice: 166800,
    lowPrice: 165100,
    accumulatedTradingVolume: 20430000,
    previousClosePrice: 166100,
  ),
  DailyPrice(
    localDate: '20260209',
    closePrice: 166100,
    openPrice: 165500,
    highPrice: 166900,
    lowPrice: 164900,
    accumulatedTradingVolume: 23120000,
    previousClosePrice: 165500,
  ),
];

List<DailyPrice> _dailyPricesForQuote(StockQuote quote) {
  const List<int> offsets = <int>[
    0,
    -300,
    500,
    -200,
    0,
    700,
    -600,
    300,
    -400,
    200,
    600,
    -500,
    -100,
    300,
    800,
    -200,
    100,
    -300,
    400,
    900,
    700,
    300,
    -100,
    -500,
    -800,
    -600,
    -400,
    -200,
    100,
    -300,
  ];

  return List<DailyPrice>.generate(offsets.length, (int index) {
    final int close = quote.currentPrice + offsets[index];
    final int previous = index == 0
        ? quote.previousClose
        : quote.currentPrice + offsets[index - 1];
    final int open = close - (index.isEven ? 200 : -150);
    final int high = close + 900;
    final int low = close - 1000;

    return DailyPrice(
      localDate: '202603${(27 - index).toString().padLeft(2, '0')}',
      closePrice: close,
      openPrice: open,
      highPrice: high,
      lowPrice: low,
      accumulatedTradingVolume:
          quote.accumulatedTradingVolume - (index * 37000),
      previousClosePrice: previous,
    );
  });
}

List<DailyPrice> _generateOlderDailyPrices({
  required DateTime startDate,
  required int count,
  required int baseClosePrice,
  required int baseVolume,
}) {
  return List<DailyPrice>.generate(count, (int index) {
    final DateTime date = startDate.subtract(Duration(days: index));
    final int wave = ((index % 9) - 4) * 180;
    final int trend = index * 35;
    final int close = baseClosePrice - trend + wave;
    final int previousClose = close - (((index % 5) - 2) * 220);
    final int open = close - (((index % 4) - 1) * 170);
    final int high = mathMax(open, close) + 620 + ((index % 3) * 120);
    final int low = mathMin(open, close) - 560 - ((index % 4) * 90);

    return DailyPrice(
      localDate:
          '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
      closePrice: close,
      openPrice: open,
      highPrice: high,
      lowPrice: low,
      accumulatedTradingVolume: baseVolume - (index * 42000),
      previousClosePrice: previousClose,
    );
  });
}

int mathMax(int a, int b) => a > b ? a : b;

int mathMin(int a, int b) => a < b ? a : b;
