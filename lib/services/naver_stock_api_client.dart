import 'dart:convert';

import 'package:http/http.dart' as http;

import '../dto/naver_stock_search_dto.dart';

class NaverStockApiException implements Exception {
  const NaverStockApiException(this.message);

  final String message;

  @override
  String toString() => 'NaverStockApiException: $message';
}

class NaverStockApiClient {
  const NaverStockApiClient({http.Client? httpClient})
    : _httpClient = httpClient;

  static final Uri _autocompleteEndpoint = Uri.https(
    'ac.stock.naver.com',
    '/ac',
  );

  final http.Client? _httpClient;

  Future<NaverStockSearchResponseDto> searchAutocomplete(String query) async {
    final String normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      return const NaverStockSearchResponseDto(
        items: <NaverStockSearchItemDto>[],
      );
    }

    final Uri uri = _autocompleteEndpoint.replace(
      queryParameters: <String, String>{
        'q': normalizedQuery,
        'target': 'stock,ipo,index,marketindicator',
      },
    );
    final http.Client? client = _httpClient;
    final http.Response response = await (client == null
        ? http.get(uri)
        : client.get(uri));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw NaverStockApiException(
        '검색 자동완성 요청 실패: HTTP ${response.statusCode}',
      );
    }

    final Object? decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, Object?>) {
      throw const NaverStockApiException('검색 자동완성 응답 형식이 올바르지 않습니다.');
    }

    return NaverStockSearchResponseDto.fromJson(decoded);
  }
}
