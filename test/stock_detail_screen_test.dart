import 'package:edencrew_assignment_starter/data/sample_stock_data.dart';
import 'package:edencrew_assignment_starter/models/models.dart';
import 'package:edencrew_assignment_starter/screens/detail/stock_detail_screen.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('종목 상세 화면은 핵심 시세 정보를 보여준다', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: StockDetailScreen(
          detail: sampleStockDetailFor(
            const Stock(symbol: '005930', name: '삼성전자', market: '코스피'),
          ),
          isFavorite: true,
        ),
      ),
    );

    expect(find.text('삼성전자'), findsOneWidget);
    expect(find.text('005930 · 코스피'), findsOneWidget);
    expect(find.text('179,700'), findsWidgets);
    expect(find.text('▼ 400 (-0.22%)'), findsOneWidget);
    expect(find.text('일별 시세'), findsOneWidget);
    expect(find.text('03.27'), findsOneWidget);
  });

  testWidgets('상세 화면에서 관심 상태를 변경할 수 있다', (WidgetTester tester) async {
    FavoriteChange? latestChange;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: StockDetailScreen(
          detail: sampleStockDetailFor(
            const Stock(symbol: '005930', name: '삼성전자', market: '코스피'),
          ),
          isFavorite: true,
          onFavoriteChanged: (FavoriteChange change) {
            latestChange = change;
          },
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.star_rounded));
    await tester.pump();

    expect(latestChange?.stock.symbol, '005930');
    expect(latestChange?.isFavorite, isFalse);
    expect(find.byIcon(Icons.star_border_rounded), findsWidgets);
    expect(find.text('관심이 해제되었습니다'), findsOneWidget);
  });

  testWidgets('차트를 터치하면 선택한 일자의 시세를 보여준다', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: StockDetailScreen(
          detail: sampleStockDetailFor(
            const Stock(symbol: '005930', name: '삼성전자', market: '코스피'),
          ),
          isFavorite: true,
        ),
      ),
    );

    expect(find.byType(ChartTooltip), findsNothing);

    await tester.tapAt(
      tester.getTopLeft(find.byType(CandlestickChart)) + const Offset(8, 100),
    );
    await tester.pump();

    expect(find.byType(ChartTooltip), findsOneWidget);
    expect(find.text('시가'), findsWidgets);
    expect(find.text('종가'), findsWidgets);
  });
}
