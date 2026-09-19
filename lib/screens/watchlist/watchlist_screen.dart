import 'package:flutter/material.dart';

import '../../data/sample_stock_data.dart';
import '../../models/models.dart';
import '../../theme/theme.dart';
import '../../utils/utils.dart';
import '../../widgets/app_bottom_tab_bar.dart';
import '../detail/stock_detail_screen.dart';
import '../search/search_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key, List<WatchlistEntry>? initialItems})
    : initialItems = initialItems ?? _sampleItems;

  final List<WatchlistEntry> initialItems;

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late List<WatchlistEntry> _items;
  WatchlistSort _sort = WatchlistSort.name;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _items = List<WatchlistEntry>.of(widget.initialItems);
  }

  Future<void> _refreshQuotes() async {
    if (_isRefreshing) {
      return;
    }

    setState(() {
      _isRefreshing = true;
      _items = _items
          .map((WatchlistEntry entry) => entry.copyWith(isQuoteLoading: true))
          .toList();
    });

    await Future<void>.delayed(const Duration(milliseconds: 550));

    if (!mounted) {
      return;
    }

    setState(() {
      _isRefreshing = false;
      _items = List<WatchlistEntry>.of(widget.initialItems);
      if (_sort != WatchlistSort.name) {
        _sortItems();
      }
    });
  }

  void _changeSort(WatchlistSort sort) {
    setState(() {
      _sort = sort;
      _sortItems();
    });
    Navigator.of(context).pop();
  }

  void _sortItems() {
    _items.sort((WatchlistEntry a, WatchlistEntry b) {
      final StockQuote? quoteA = a.quote;
      final StockQuote? quoteB = b.quote;

      switch (_sort) {
        case WatchlistSort.currentPrice:
          return _compareDescendingNullable(
            quoteA?.currentPrice,
            quoteB?.currentPrice,
          );
        case WatchlistSort.changeRate:
          return _compareDescendingNullable(
            quoteA?.changeRate,
            quoteB?.changeRate,
          );
        case WatchlistSort.name:
          return a.stock.name.compareTo(b.stock.name);
      }
    });
  }

  int _compareDescendingNullable(num? a, num? b) {
    if (a == null && b == null) {
      return 0;
    }
    if (a == null) {
      return 1;
    }
    if (b == null) {
      return -1;
    }
    return b.compareTo(a);
  }

  Future<void> _showSortSheet() {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surfaceRaised,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(dimens.radiusLg),
            ),
          ),
          padding: EdgeInsets.only(
            top: dimens.space3,
            bottom: MediaQuery.paddingOf(context).bottom + dimens.space3,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: WatchlistSort.values.map((WatchlistSort sort) {
              final bool isSelected = sort == _sort;
              return InkWell(
                onTap: () => _changeSort(sort),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: dimens.space5,
                    vertical: dimens.space4,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          sort.label,
                          style: TextStyle(
                            color: isSelected
                                ? colors.textPrimary
                                : colors.textSecondary,
                            fontSize: 15,
                            fontWeight: AppTypography.medium,
                            height: 20 / 15,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_rounded,
                          color: colors.accentDefault,
                          size: dimens.iconMd,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => SearchScreen(
          favoriteSymbols: _items
              .map((WatchlistEntry entry) => entry.stock.symbol)
              .toSet(),
          onFavoriteChanged: _handleFavoriteChanged,
        ),
      ),
    );
  }

  void _handleFavoriteChanged(FavoriteChange change) {
    setState(() {
      final int index = _items.indexWhere(
        (WatchlistEntry entry) => entry.stock.symbol == change.stock.symbol,
      );

      if (change.isFavorite && index < 0) {
        _items.add(WatchlistEntry(stock: change.stock));
      } else if (!change.isFavorite && index >= 0) {
        _items.removeAt(index);
      }

      if (_sort != WatchlistSort.name) {
        _sortItems();
      }
    });
  }

  void _openDetail(WatchlistEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => StockDetailScreen(
          detail: sampleStockDetailFor(entry.stock),
          isFavorite: true,
          onFavoriteChanged: _handleFavoriteChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            WatchlistHeader(
              selectedSort: _sort,
              isRefreshing: _isRefreshing,
              onSortTap: _showSortSheet,
              onRefreshTap: _refreshQuotes,
            ),
            Expanded(
              child: _items.isEmpty
                  ? const WatchlistEmptyState()
                  : WatchlistList(items: _items, onItemTap: _openDetail),
            ),
            AppBottomTabBar(
              selectedTab: AppTab.watchlist,
              onSearchTap: _openSearch,
            ),
          ],
        ),
      ),
    );
  }
}

class WatchlistEntry {
  const WatchlistEntry({
    required this.stock,
    this.quote,
    this.isQuoteLoading = false,
  });

  final Stock stock;
  final StockQuote? quote;
  final bool isQuoteLoading;

  WatchlistEntry copyWith({
    Stock? stock,
    StockQuote? quote,
    bool? isQuoteLoading,
  }) {
    return WatchlistEntry(
      stock: stock ?? this.stock,
      quote: quote ?? this.quote,
      isQuoteLoading: isQuoteLoading ?? this.isQuoteLoading,
    );
  }
}

class WatchlistHeader extends StatelessWidget {
  const WatchlistHeader({
    required this.selectedSort,
    required this.isRefreshing,
    required this.onSortTap,
    required this.onRefreshTap,
    super.key,
  });

  final WatchlistSort selectedSort;
  final bool isRefreshing;
  final VoidCallback onSortTap;
  final VoidCallback onRefreshTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return SizedBox(
      height: 52,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dimens.space4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                '관심',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 19,
                  fontWeight: AppTypography.bold,
                  height: 22 / 19,
                ),
              ),
            ),
            InkWell(
              onTap: onSortTap,
              borderRadius: BorderRadius.circular(dimens.radiusSm),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: dimens.space1),
                child: Row(
                  children: <Widget>[
                    Text(
                      selectedSort.label,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 13,
                        fontWeight: AppTypography.bold,
                        height: 18 / 13,
                      ),
                    ),
                    SizedBox(width: dimens.space1),
                    Icon(
                      Icons.arrow_downward_rounded,
                      color: colors.textSecondary,
                      size: dimens.iconMd,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: dimens.space4),
            IconButton(
              onPressed: isRefreshing ? null : onRefreshTap,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints.tight(
                Size.square(dimens.iconMd + dimens.space2),
              ),
              icon: Icon(
                Icons.refresh_rounded,
                color: isRefreshing
                    ? colors.textDisabled
                    : colors.textSecondary,
                size: dimens.iconMd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WatchlistList extends StatelessWidget {
  const WatchlistList({
    required this.items,
    required this.onItemTap,
    super.key,
  });

  final List<WatchlistEntry> items;
  final ValueChanged<WatchlistEntry> onItemTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final WatchlistEntry entry = items[index];
        return WatchlistRow(entry: entry, onTap: () => onItemTap(entry));
      },
    );
  }
}

class WatchlistRow extends StatelessWidget {
  const WatchlistRow({required this.entry, required this.onTap, super.key});

  final WatchlistEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final StockQuote? quote = entry.quote;

    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: dimens.rowMinHeight),
        padding: EdgeInsets.symmetric(
          horizontal: dimens.space4,
          vertical: dimens.space3,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.borderSubtle,
              width: dimens.borderHairline,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    entry.stock.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 15,
                      fontWeight: AppTypography.medium,
                      height: 20 / 15,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    entry.stock.symbolWithMarket,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 11,
                      fontWeight: AppTypography.regular,
                      height: 14 / 11,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: dimens.space3),
            if (entry.isQuoteLoading || quote == null)
              const QuoteSkeleton()
            else
              QuoteText(quote: quote),
          ],
        ),
      ),
    );
  }
}

class QuoteText extends StatelessWidget {
  const QuoteText({required this.quote, super.key});

  final StockQuote quote;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final Color changeColor = switch (quote.direction) {
      PriceDirection.up => colors.priceUpText,
      PriceDirection.down => colors.priceDownText,
      PriceDirection.flat => colors.priceFlatText,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          formatNumber(quote.currentPrice),
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 15,
            fontWeight: AppTypography.medium,
            height: 20 / 15,
          ),
        ),
        SizedBox(height: 2),
        Text(
          formatPriceChange(quote.changeAmount, quote.changeRate),
          style: TextStyle(
            color: changeColor,
            fontSize: 11,
            fontWeight: AppTypography.regular,
            height: 14 / 11,
          ),
        ),
      ],
    );
  }
}

class QuoteSkeleton extends StatelessWidget {
  const QuoteSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 64,
          height: 16,
          decoration: BoxDecoration(
            color: colors.feedbackSkeleton,
            borderRadius: BorderRadius.circular(dimens.radiusSm),
          ),
        ),
        SizedBox(height: dimens.space2),
        Container(
          width: 48,
          height: 12,
          decoration: BoxDecoration(
            color: colors.feedbackSkeleton,
            borderRadius: BorderRadius.circular(dimens.radiusSm),
          ),
        ),
      ],
    );
  }
}

class WatchlistEmptyState extends StatelessWidget {
  const WatchlistEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dimens.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.star_border_rounded,
              color: colors.textTertiary,
              size: 44,
            ),
            SizedBox(height: dimens.space3),
            Text(
              '관심 종목이 없습니다',
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 19,
                fontWeight: AppTypography.bold,
                height: 22 / 19,
              ),
            ),
            SizedBox(height: dimens.space3),
            Text(
              '검색 탭에서 종목을 찾아\n별 아이콘을 눌러 추가해 주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textTertiary,
                fontSize: 11,
                fontWeight: AppTypography.regular,
                height: 14 / 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const List<WatchlistEntry> _sampleItems = <WatchlistEntry>[
  WatchlistEntry(
    stock: Stock(symbol: '005930', name: '삼성전자', market: '코스피'),
    quote: StockQuote(
      symbol: '005930',
      currentPrice: 179700,
      previousClose: 180100,
      openPrice: 179000,
      highPrice: 181000,
      lowPrice: 178900,
      accumulatedTradingVolume: 29113000,
      listedStockCount: 5969782550,
    ),
  ),
  WatchlistEntry(
    stock: Stock(symbol: '000660', name: 'SK하이닉스', market: '코스피'),
    quote: StockQuote(
      symbol: '000660',
      currentPrice: 412500,
      previousClose: 403000,
      openPrice: 405000,
      highPrice: 415500,
      lowPrice: 402000,
      accumulatedTradingVolume: 7240000,
      listedStockCount: 728002365,
    ),
  ),
  WatchlistEntry(
    stock: Stock(symbol: '035720', name: '카카오', market: '코스피'),
    quote: StockQuote(
      symbol: '035720',
      currentPrice: 61300,
      previousClose: 62100,
      openPrice: 62000,
      highPrice: 62600,
      lowPrice: 61000,
      accumulatedTradingVolume: 1395000,
      listedStockCount: 443586406,
    ),
  ),
  WatchlistEntry(
    stock: Stock(symbol: '247540', name: '에코프로비엠', market: '코스닥'),
    quote: StockQuote(
      symbol: '247540',
      currentPrice: 195400,
      previousClose: 195400,
      openPrice: 195000,
      highPrice: 198000,
      lowPrice: 193200,
      accumulatedTradingVolume: 614000,
      listedStockCount: 97801344,
    ),
  ),
  WatchlistEntry(
    stock: Stock(symbol: '373220', name: 'LG에너지솔루션', market: '코스피'),
  ),
];
