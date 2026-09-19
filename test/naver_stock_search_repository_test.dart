import 'package:edencrew_assignment_starter/dto/naver_stock_search_dto.dart';
import 'package:edencrew_assignment_starter/models/models.dart';
import 'package:edencrew_assignment_starter/repositories/stock_search_repository.dart';
import 'package:edencrew_assignment_starter/services/naver_stock_api_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('네이버 자동완성 응답에서 국내 주식만 앱 모델로 변환한다', () async {
    final StockSearchRepository repository = NaverStockSearchRepository(
      apiClient: const _FakeNaverStockApiClient(),
      fallbackToSamples: false,
    );

    final List<Stock> results = await repository.search('삼성');

    expect(results, const <Stock>[
      Stock(symbol: '005930', name: '삼성전자', market: '코스피'),
      Stock(symbol: '207940', name: '삼성바이오로직스', market: '코스피'),
    ]);
  });

  test('자동완성 요청이 실패하면 샘플 검색 결과로 대체한다', () async {
    final StockSearchRepository repository = NaverStockSearchRepository(
      apiClient: const _FailingNaverStockApiClient(),
    );

    final List<Stock> results = await repository.search('삼성전자');

    expect(
      results,
      contains(const Stock(symbol: '005930', name: '삼성전자', market: '코스피')),
    );
  });
}

class _FakeNaverStockApiClient extends NaverStockApiClient {
  const _FakeNaverStockApiClient();

  @override
  Future<NaverStockSearchResponseDto> searchAutocomplete(String query) async {
    return const NaverStockSearchResponseDto(
      items: <NaverStockSearchItemDto>[
        NaverStockSearchItemDto(
          code: '005930',
          name: '삼성전자',
          typeName: '코스피',
          nationCode: 'KOR',
          category: 'stock',
        ),
        NaverStockSearchItemDto(
          code: '207940',
          name: '삼성바이오로직스',
          typeName: '코스피',
          nationCode: 'KOR',
          category: 'stock',
        ),
        NaverStockSearchItemDto(
          code: '000001',
          name: '코스피',
          typeName: '국내지수',
          nationCode: 'KOR',
          category: 'index',
        ),
        NaverStockSearchItemDto(
          code: 'AAPL',
          name: '애플',
          typeName: '나스닥',
          nationCode: 'USA',
          category: 'stock',
        ),
      ],
    );
  }
}

class _FailingNaverStockApiClient extends NaverStockApiClient {
  const _FailingNaverStockApiClient();

  @override
  Future<NaverStockSearchResponseDto> searchAutocomplete(String query) async {
    throw const NaverStockApiException('검색 실패');
  }
}
