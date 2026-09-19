import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/theme.dart';
import '../../utils/utils.dart';
import '../../widgets/favorite_snack_bar.dart';

class StockDetailScreen extends StatefulWidget {
  const StockDetailScreen({
    required this.detail,
    required this.isFavorite,
    this.onFavoriteChanged,
    super.key,
  });

  final StockDetail detail;
  final bool isFavorite;
  final ValueChanged<FavoriteChange>? onFavoriteChanged;

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  late bool _isFavorite;
  DetailPeriod _selectedPeriod = DetailPeriod.oneMonth;
  DailyPrice? _selectedDailyPrice;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onFavoriteChanged?.call(
      FavoriteChange(stock: widget.detail.stock, isFavorite: _isFavorite),
    );
    _showFavoriteMessage();
  }

  void _showFavoriteMessage() {
    showFavoriteSnackBar(context, isFavorite: _isFavorite, bottomMargin: 24);
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            StockDetailAppBar(
              detail: widget.detail,
              isFavorite: _isFavorite,
              onBackTap: () => Navigator.of(context).pop(),
              onFavoriteTap: _toggleFavorite,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  dimens.space4,
                  14,
                  dimens.space4,
                  MediaQuery.paddingOf(context).bottom + dimens.space4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    PriceOverview(
                      detail: widget.detail,
                      selectedPeriod: _selectedPeriod,
                      selectedDailyPrice: _selectedDailyPrice,
                      onPeriodChanged: (DetailPeriod period) {
                        setState(() {
                          _selectedPeriod = period;
                          _selectedDailyPrice = null;
                        });
                      },
                      onDailyPriceSelected: (DailyPrice price) {
                        setState(() {
                          _selectedDailyPrice = price;
                        });
                      },
                    ),
                    SizedBox(height: dimens.space6),
                    DailyPriceSection(
                      prices: widget.detail.dailyPrices.take(5).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum DetailPeriod {
  oneMonth('1개월', 60),
  threeMonths('3개월', 120),
  sixMonths('6개월', 180),
  oneYear('1년', 240);

  const DetailPeriod(this.label, this.visibleDays);

  final String label;
  final int visibleDays;
}

class StockDetailAppBar extends StatelessWidget {
  const StockDetailAppBar({
    required this.detail,
    required this.isFavorite,
    required this.onBackTap,
    required this.onFavoriteTap,
    super.key,
  });

  final StockDetail detail;
  final bool isFavorite;
  final VoidCallback onBackTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Container(
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: dimens.space4),
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
          IconButton(
            onPressed: onBackTap,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
            icon: Icon(
              Icons.arrow_back_rounded,
              color: colors.textSecondary,
              size: 25,
            ),
          ),
          SizedBox(width: dimens.space1),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  detail.stock.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: AppTypography.medium,
                    height: 20 / 15,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  detail.stock.symbolWithMarket,
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
          IconButton(
            onPressed: onFavoriteTap,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
            icon: Icon(
              isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: isFavorite
                  ? colors.favoriteActive
                  : colors.favoriteInactive,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class PriceOverview extends StatelessWidget {
  const PriceOverview({
    required this.detail,
    required this.selectedPeriod,
    required this.selectedDailyPrice,
    required this.onPeriodChanged,
    required this.onDailyPriceSelected,
    super.key,
  });

  final StockDetail detail;
  final DetailPeriod selectedPeriod;
  final DailyPrice? selectedDailyPrice;
  final ValueChanged<DetailPeriod> onPeriodChanged;
  final ValueChanged<DailyPrice> onDailyPriceSelected;

  @override
  Widget build(BuildContext context) {
    final AppDimens dimens = context.dimens;
    final List<DailyPrice> chartPrices = _visiblePricesForPeriod(
      detail.dailyPrices,
      selectedPeriod,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CurrentPriceLine(quote: detail.quote),
        SizedBox(height: dimens.space4),
        PeriodTabs(
          selectedPeriod: selectedPeriod,
          onPeriodChanged: onPeriodChanged,
        ),
        SizedBox(height: dimens.space4),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: CandlestickChart(
            prices: chartPrices,
            selectedPrice: selectedDailyPrice,
            onSelected: onDailyPriceSelected,
          ),
        ),
        SizedBox(height: dimens.space4),
        QuoteSummaryGrid(quote: detail.quote),
      ],
    );
  }
}

class CurrentPriceLine extends StatelessWidget {
  const CurrentPriceLine({required this.quote, super.key});

  final StockQuote quote;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final Color changeColor = switch (quote.direction) {
      PriceDirection.up => colors.priceUpText,
      PriceDirection.down => colors.priceDownText,
      PriceDirection.flat => colors.priceFlatText,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Text(
          formatNumber(quote.currentPrice),
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 30,
            fontWeight: AppTypography.bold,
            height: 36 / 30,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            _formatDetailChange(quote),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: changeColor,
              fontSize: 15,
              fontWeight: AppTypography.medium,
              height: 20 / 15,
            ),
          ),
        ),
      ],
    );
  }
}

class PeriodTabs extends StatelessWidget {
  const PeriodTabs({
    required this.selectedPeriod,
    required this.onPeriodChanged,
    super.key,
  });

  final DetailPeriod selectedPeriod;
  final ValueChanged<DetailPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Row(
      children: DetailPeriod.values.map((DetailPeriod period) {
        final bool isSelected = period == selectedPeriod;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: InkWell(
              onTap: () => onPeriodChanged(period),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? colors.accentBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  period.label,
                  style: TextStyle(
                    color: isSelected
                        ? colors.accentDefault
                        : colors.textSecondary,
                    fontSize: 13,
                    fontWeight: AppTypography.regular,
                    height: 18 / 13,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CandlestickChart extends StatelessWidget {
  const CandlestickChart({
    required this.prices,
    required this.selectedPrice,
    required this.onSelected,
    super.key,
  });

  final List<DailyPrice> prices;
  final DailyPrice? selectedPrice;
  final ValueChanged<DailyPrice> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (TapDownDetails details) {
            _selectPriceAt(details.localPosition.dx, constraints.maxWidth);
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            _selectPriceAt(details.localPosition.dx, constraints.maxWidth);
          },
          child: Stack(
            children: <Widget>[
              CustomPaint(
                painter: CandlestickChartPainter(
                  prices: prices,
                  selectedPrice: selectedPrice,
                  colors: context.colors,
                ),
                child: const SizedBox.expand(),
              ),
              if (selectedPrice != null)
                Positioned(
                  left: 0,
                  top: 0,
                  child: ChartTooltip(price: selectedPrice!),
                ),
            ],
          ),
        );
      },
    );
  }

  void _selectPriceAt(double localX, double width) {
    if (prices.isEmpty || width <= 0) {
      return;
    }

    final List<DailyPrice> chronological = prices.reversed.toList();
    final double slotWidth = width / chronological.length;
    final int index = (localX / slotWidth).floor().clamp(
      0,
      chronological.length - 1,
    );
    onSelected(chronological[index]);
  }
}

class ChartTooltip extends StatelessWidget {
  const ChartTooltip({required this.price, super.key});

  final DailyPrice price;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Container(
      width: 168,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceOverlay.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            formatDateAsMonthDay(price.localDate),
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 11,
              fontWeight: AppTypography.medium,
              height: 14 / 11,
            ),
          ),
          const SizedBox(height: 4),
          _ChartTooltipLine(label: '시가', value: formatNumber(price.openPrice)),
          _ChartTooltipLine(label: '고가', value: formatNumber(price.highPrice)),
          _ChartTooltipLine(label: '저가', value: formatNumber(price.lowPrice)),
          _ChartTooltipLine(label: '종가', value: formatNumber(price.closePrice)),
        ],
      ),
    );
  }
}

class _ChartTooltipLine extends StatelessWidget {
  const _ChartTooltipLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Row(
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 11,
            fontWeight: AppTypography.regular,
            height: 14 / 11,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 11,
            fontWeight: AppTypography.regular,
            height: 14 / 11,
          ),
        ),
      ],
    );
  }
}

class CandlestickChartPainter extends CustomPainter {
  CandlestickChartPainter({
    required this.prices,
    required this.selectedPrice,
    required this.colors,
  });

  final List<DailyPrice> prices;
  final DailyPrice? selectedPrice;
  final AppColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) {
      return;
    }

    final List<DailyPrice> visible = prices.reversed.toList();
    final int minPrice = visible
        .map((DailyPrice price) => price.lowPrice)
        .reduce(math.min);
    final int maxPrice = visible
        .map((DailyPrice price) => price.highPrice)
        .reduce(math.max);
    final int priceRange = math.max(1, maxPrice - minPrice);
    final double slotWidth = size.width / visible.length;
    final double candleWidth = math.max(2.5, math.min(7, slotWidth * 0.72));
    final Paint wickPaint = Paint()
      ..color = colors.chartBaseline
      ..strokeWidth = 0.6
      ..strokeCap = StrokeCap.square;

    double priceToY(num price) {
      final double ratio = (price - minPrice) / priceRange;
      return size.height -
          (ratio * (size.height * 0.72)) -
          (size.height * 0.12);
    }

    for (int index = 0; index < visible.length; index += 1) {
      final DailyPrice price = visible[index];
      final double centerX = (slotWidth * index) + (slotWidth / 2);
      final double highY = priceToY(price.highPrice);
      final double lowY = priceToY(price.lowPrice);
      final double openY = priceToY(price.openPrice);
      final double closeY = priceToY(price.closePrice);
      final Color candleColor = switch (price.direction) {
        PriceDirection.up => colors.chartLineUp,
        PriceDirection.down => colors.chartLineDown,
        PriceDirection.flat => colors.chartBaseline,
      };
      final Paint bodyPaint = Paint()..color = candleColor;

      canvas.drawLine(Offset(centerX, highY), Offset(centerX, lowY), wickPaint);

      final double top = math.min(openY, closeY);
      final double bottom = math.max(openY, closeY);
      final Rect bodyRect = Rect.fromLTRB(
        centerX - (candleWidth / 2),
        top,
        centerX + (candleWidth / 2),
        math.max(top + 1, bottom),
      );
      canvas.drawRect(bodyRect, bodyPaint);
    }

    final DailyPrice? selected = selectedPrice;
    if (selected != null) {
      final int selectedIndex = visible.indexWhere(
        (DailyPrice price) => price.localDate == selected.localDate,
      );
      if (selectedIndex >= 0) {
        final double centerX = (slotWidth * selectedIndex) + (slotWidth / 2);
        final Paint guidePaint = Paint()
          ..color = colors.textSecondary.withValues(alpha: 0.75)
          ..strokeWidth = 0.8;
        final Paint markerPaint = Paint()
          ..color = colors.accentDefault
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6;

        canvas.drawLine(
          Offset(centerX, size.height * 0.04),
          Offset(centerX, size.height * 0.94),
          guidePaint,
        );
        canvas.drawCircle(
          Offset(centerX, priceToY(selected.closePrice)),
          5,
          markerPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CandlestickChartPainter oldDelegate) {
    return oldDelegate.prices != prices ||
        oldDelegate.selectedPrice != selectedPrice ||
        oldDelegate.colors != colors;
  }
}

class QuoteSummaryGrid extends StatelessWidget {
  const QuoteSummaryGrid({required this.quote, super.key});

  final StockQuote quote;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double gap = 8;
        final double thirdWidth = (constraints.maxWidth - (gap * 2)) / 3;
        final double halfWidth = (constraints.maxWidth - gap) / 2;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            SummaryCell(
              label: '시가',
              value: formatNumber(quote.openPrice),
              width: thirdWidth,
            ),
            SummaryCell(
              label: '고가',
              value: formatNumber(quote.highPrice),
              width: thirdWidth,
            ),
            SummaryCell(
              label: '저가',
              value: formatNumber(quote.lowPrice),
              width: thirdWidth,
            ),
            SummaryCell(
              label: '거래량',
              value: formatCompactVolume(quote.accumulatedTradingVolume),
              width: halfWidth,
            ),
            SummaryCell(
              label: '시가총액',
              value: formatMarketCap(quote.marketCap),
              width: halfWidth,
            ),
          ],
        );
      },
    );
  }
}

class SummaryCell extends StatelessWidget {
  const SummaryCell({
    required this.label,
    required this.value,
    required this.width,
    super.key,
  });

  final String label;
  final String value;
  final double width;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Container(
      width: width,
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 11,
              fontWeight: AppTypography.regular,
              height: 14 / 11,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 15,
              fontWeight: AppTypography.medium,
              height: 20 / 15,
            ),
          ),
        ],
      ),
    );
  }
}

class DailyPriceSection extends StatelessWidget {
  const DailyPriceSection({required this.prices, super.key});

  final List<DailyPrice> prices;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '일별 시세',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 13,
            fontWeight: AppTypography.bold,
            height: 18 / 13,
          ),
        ),
        SizedBox(height: dimens.space1),
        DailyPriceHeader(),
        ...prices.map((DailyPrice price) => DailyPriceRow(price: price)),
      ],
    );
  }
}

class DailyPriceHeader extends StatelessWidget {
  const DailyPriceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return DailyPriceLine(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      children: <Widget>[
        _DailyCell(
          text: '날짜',
          alignment: Alignment.centerLeft,
          color: colors.textSecondary,
        ),
        _DailyCell(text: '종가', color: colors.textSecondary),
        _DailyCell(text: '등락', color: colors.textSecondary),
        _DailyCell(text: '거래량', color: colors.textSecondary),
      ],
    );
  }
}

class DailyPriceRow extends StatelessWidget {
  const DailyPriceRow({required this.price, super.key});

  final DailyPrice price;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final int change = price.changeAmount ?? 0;
    final Color changeColor = switch (price.direction) {
      PriceDirection.up => colors.priceUpText,
      PriceDirection.down => colors.priceDownText,
      PriceDirection.flat => colors.priceFlatText,
    };

    return DailyPriceLine(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      children: <Widget>[
        _DailyCell(
          text: formatDateAsMonthDay(price.localDate),
          alignment: Alignment.centerLeft,
          color: colors.textSecondary,
        ),
        _DailyCell(
          text: formatNumber(price.closePrice),
          color: colors.textPrimary,
        ),
        _DailyCell(text: formatSignedNumber(change), color: changeColor),
        _DailyCell(
          text: formatNumber(price.accumulatedTradingVolume),
          color: colors.textSecondary,
        ),
      ],
    );
  }
}

class DailyPriceLine extends StatelessWidget {
  const DailyPriceLine({required this.children, this.decoration, super.key});

  final List<Widget> children;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: decoration,
      child: Row(
        children: <Widget>[
          SizedBox(width: 46, child: children[0]),
          const SizedBox(width: 8),
          Expanded(child: children[1]),
          const SizedBox(width: 8),
          Expanded(child: children[2]),
          const SizedBox(width: 8),
          Expanded(child: children[3]),
        ],
      ),
    );
  }
}

class _DailyCell extends StatelessWidget {
  const _DailyCell({
    required this.text,
    required this.color,
    this.alignment = Alignment.centerRight,
  });

  final String text;
  final Color color;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: AppTypography.regular,
          height: 14 / 11,
        ),
      ),
    );
  }
}

String _formatDetailChange(StockQuote quote) {
  return switch (quote.direction) {
    PriceDirection.up =>
      '▲ ${formatNumber(quote.changeAmount.abs())} (${formatPercent(quote.changeRate)})',
    PriceDirection.down =>
      '▼ ${formatNumber(quote.changeAmount.abs())} (${formatPercent(quote.changeRate)})',
    PriceDirection.flat =>
      '0 (${formatPercent(quote.changeRate, signed: false)})',
  };
}

List<DailyPrice> _visiblePricesForPeriod(
  List<DailyPrice> prices,
  DetailPeriod period,
) {
  return prices.take(period.visibleDays).toList();
}
