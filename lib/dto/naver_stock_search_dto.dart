import '../models/models.dart';

class NaverStockSearchResponseDto {
  const NaverStockSearchResponseDto({required this.items});

  factory NaverStockSearchResponseDto.fromJson(Map<String, Object?> json) {
    final Object? rawItems = json['items'];
    final List<Object?> itemList = rawItems is List<Object?>
        ? rawItems
        : <Object?>[];

    return NaverStockSearchResponseDto(
      items: itemList
          .whereType<Map<String, Object?>>()
          .map(NaverStockSearchItemDto.fromJson)
          .toList(),
    );
  }

  final List<NaverStockSearchItemDto> items;
}

class NaverStockSearchItemDto {
  const NaverStockSearchItemDto({
    required this.code,
    required this.name,
    required this.typeName,
    required this.nationCode,
    required this.category,
  });

  factory NaverStockSearchItemDto.fromJson(Map<String, Object?> json) {
    return NaverStockSearchItemDto(
      code: _stringValue(json['code']),
      name: _stringValue(json['name']),
      typeName: _stringValue(json['typeName']),
      nationCode: _stringValue(json['nationCode']),
      category: _stringValue(json['category']),
    );
  }

  final String code;
  final String name;
  final String typeName;
  final String nationCode;
  final String category;

  bool get isDomesticStock {
    return nationCode == 'KOR' &&
        category == 'stock' &&
        RegExp(r'^\d{6}$').hasMatch(code) &&
        name.isNotEmpty &&
        typeName.isNotEmpty;
  }

  Stock toStock() {
    return Stock.fromNaverSearch(symbol: code, name: name, market: typeName);
  }
}

String _stringValue(Object? value) => value is String ? value : '';
