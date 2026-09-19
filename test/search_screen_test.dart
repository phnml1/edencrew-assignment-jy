import 'package:edencrew_assignment_starter/models/models.dart';
import 'package:edencrew_assignment_starter/screens/search/search_screen.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildSearchScreen({
    Set<String> favoriteSymbols = const <String>{},
    ValueChanged<FavoriteChange>? onFavoriteChanged,
  }) {
    return MaterialApp(
      theme: AppTheme.dark,
      home: SearchScreen(
        favoriteSymbols: favoriteSymbols,
        onFavoriteChanged: onFavoriteChanged ?? (_) {},
      ),
    );
  }

  testWidgets('검색어가 없으면 초기 안내를 보여준다', (WidgetTester tester) async {
    await tester.pumpWidget(buildSearchScreen());

    expect(find.text('종목을 검색해 보세요'), findsOneWidget);
    expect(find.text('종목명 또는 종목코드 6자리로\n검색하실 수 있습니다.'), findsOneWidget);
  });

  testWidgets('종목명 검색 결과를 보여준다', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildSearchScreen(favoriteSymbols: <String>{'005930'}),
    );

    await tester.enterText(find.byType(TextField), '삼성');
    await tester.pump();

    expect(find.text('005930 · 코스피'), findsOneWidget);
    expect(find.text('005935 · 코스피'), findsOneWidget);
    expect(find.text('207940 · 코스피'), findsOneWidget);
  });

  testWidgets('검색 결과가 없으면 안내 문구를 보여준다', (WidgetTester tester) async {
    await tester.pumpWidget(buildSearchScreen());

    await tester.enterText(find.byType(TextField), 'ㄱㄴㄷㄹㅁㅂㅅ');
    await tester.pump();

    expect(find.text('검색 결과가 없습니다'), findsOneWidget);
    expect(find.text("'ㄱㄴㄷㄹㅁㅂㅅ'와\n일치하는 검색 결과를 찾지 못했습니다."), findsOneWidget);
  });

  testWidgets('별 아이콘을 누르면 관심 변경을 알린다', (WidgetTester tester) async {
    FavoriteChange? latestChange;

    await tester.pumpWidget(
      buildSearchScreen(
        onFavoriteChanged: (FavoriteChange change) {
          latestChange = change;
        },
      ),
    );

    await tester.enterText(find.byType(TextField), '삼성');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.star_border_rounded).first);
    await tester.pump();

    expect(
      latestChange?.stock,
      const Stock(symbol: '005930', name: '삼성전자', market: '코스피'),
    );
    expect(latestChange?.isFavorite, isTrue);
    expect(find.text('관심이 등록되었습니다'), findsOneWidget);

    final SnackBar snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.margin, const EdgeInsets.fromLTRB(16, 0, 16, 109));
    expect(
      snackBar.padding,
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  });
}
