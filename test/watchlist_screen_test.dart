import 'package:edencrew_assignment_starter/screens/watchlist/watchlist_screen.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('관심종목이 없으면 빈 상태를 보여준다', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const WatchlistScreen(initialItems: <WatchlistEntry>[]),
      ),
    );

    expect(find.text('관심 종목이 없습니다'), findsOneWidget);
    expect(find.text('검색 탭에서 종목을 찾아\n별 아이콘을 눌러 추가해 주세요.'), findsOneWidget);
  });
}
