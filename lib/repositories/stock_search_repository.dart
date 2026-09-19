import '../data/sample_stock_data.dart';
import '../dto/naver_stock_search_dto.dart';
import '../models/models.dart';
import '../services/naver_stock_api_client.dart';

abstract interface class StockSearchRepository {
  Future<List<Stock>> search(String query);
}

class NaverStockSearchRepository implements StockSearchRepository {
  const NaverStockSearchRepository({
    this.apiClient = const NaverStockApiClient(),
    this.fallbackToSamples = true,
  });

  final NaverStockApiClient apiClient;
  final bool fallbackToSamples;

  @override
  Future<List<Stock>> search(String query) async {
    final String normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      return const <Stock>[];
    }

    try {
      final NaverStockSearchResponseDto response = await apiClient
          .searchAutocomplete(normalizedQuery);

      return response.items
          .where((NaverStockSearchItemDto item) => item.isDomesticStock)
          .map((NaverStockSearchItemDto item) => item.toStock())
          .toList(growable: false);
    } on Object {
      if (!fallbackToSamples) {
        rethrow;
      }
      return searchSampleStocks(normalizedQuery);
    }
  }
}

List<Stock> searchSampleStocks(String query) {
  final String normalizedQuery = query.trim();
  if (normalizedQuery.isEmpty) {
    return const <Stock>[];
  }

  return sampleStocks
      .where((Stock stock) {
        return stock.name.contains(normalizedQuery) ||
            stock.symbol.contains(normalizedQuery);
      })
      .toList(growable: false);
}
