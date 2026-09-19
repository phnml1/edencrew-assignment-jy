import 'package:flutter/material.dart';

import '../../data/sample_stock_data.dart';
import '../../models/models.dart';
import '../../theme/theme.dart';
import '../../widgets/app_bottom_tab_bar.dart';
import '../../widgets/favorite_snack_bar.dart';
import '../detail/stock_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    required this.favoriteSymbols,
    required this.onFavoriteChanged,
    super.key,
  });

  final Set<String> favoriteSymbols;
  final ValueChanged<FavoriteChange> onFavoriteChanged;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;
  late final Set<String> _favoriteSymbols;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _favoriteSymbols = Set<String>.of(widget.favoriteSymbols);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changeQuery(String value) {
    setState(() {
      _query = value.trim();
    });
  }

  void _clearQuery() {
    _controller.clear();
    _changeQuery('');
  }

  void _toggleFavorite(Stock stock) {
    final bool willFavorite = !_favoriteSymbols.contains(stock.symbol);

    setState(() {
      if (willFavorite) {
        _favoriteSymbols.add(stock.symbol);
      } else {
        _favoriteSymbols.remove(stock.symbol);
      }
    });

    widget.onFavoriteChanged(
      FavoriteChange(stock: stock, isFavorite: willFavorite),
    );
    _showFavoriteMessage(willFavorite);
  }

  void _applyFavoriteChange(FavoriteChange change) {
    setState(() {
      if (change.isFavorite) {
        _favoriteSymbols.add(change.stock.symbol);
      } else {
        _favoriteSymbols.remove(change.stock.symbol);
      }
    });

    widget.onFavoriteChanged(change);
  }

  void _openDetail(Stock stock) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => StockDetailScreen(
          detail: sampleStockDetailFor(stock),
          isFavorite: _favoriteSymbols.contains(stock.symbol),
          onFavoriteChanged: _applyFavoriteChange,
        ),
      ),
    );
  }

  void _showFavoriteMessage(bool isFavorite) {
    showFavoriteSnackBar(context, isFavorite: isFavorite, bottomMargin: 109);
  }

  List<Stock> get _results {
    if (_query.isEmpty) {
      return const <Stock>[];
    }

    return _searchStocks.where((Stock stock) {
      return stock.name.contains(_query) || stock.symbol.contains(_query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final List<Stock> results = _results;

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            SearchField(
              controller: _controller,
              onChanged: _changeQuery,
              onClear: _clearQuery,
            ),
            Expanded(
              child: _query.isEmpty
                  ? const SearchInitialState()
                  : results.isEmpty
                  ? SearchNoResultState(query: _query)
                  : SearchResultList(
                      query: _query,
                      results: results,
                      favoriteSymbols: _favoriteSymbols,
                      onStockTap: _openDetail,
                      onFavoriteTap: _toggleFavorite,
                    ),
            ),
            AppBottomTabBar(
              selectedTab: AppTab.search,
              onWatchlistTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        dimens.space4,
        dimens.space2,
        dimens.space4,
        dimens.space3,
      ),
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: controller,
          cursorColor: colors.textPrimary,
          onChanged: onChanged,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 15,
            fontWeight: AppTypography.medium,
            height: 20 / 15,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.surfaceSunken,
            hintText: '종목명 또는 종목코드',
            hintStyle: TextStyle(
              color: colors.textTertiary,
              fontSize: 15,
              fontWeight: AppTypography.medium,
              height: 20 / 15,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: colors.textTertiary,
              size: 22,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (BuildContext context, TextEditingValue value, _) {
                if (value.text.isEmpty) {
                  return const SizedBox.shrink();
                }
                return IconButton(
                  onPressed: onClear,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.close_rounded,
                    color: colors.textTertiary,
                    size: 22,
                  ),
                );
              },
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(dimens.radiusMd),
              borderSide: BorderSide(
                color: colors.borderStrong,
                width: dimens.borderHairline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(dimens.radiusMd),
              borderSide: BorderSide(
                color: colors.borderStrong,
                width: dimens.borderHairline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchInitialState extends StatelessWidget {
  const SearchInitialState({super.key});

  @override
  Widget build(BuildContext context) {
    return const SearchEmptyMessage(
      icon: Icons.search_rounded,
      title: '종목을 검색해 보세요',
      description: '종목명 또는 종목코드 6자리로\n검색하실 수 있습니다.',
    );
  }
}

class SearchNoResultState extends StatelessWidget {
  const SearchNoResultState({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context) {
    return SearchEmptyMessage(
      icon: Icons.manage_search_rounded,
      title: '검색 결과가 없습니다',
      description: "'$query'와\n일치하는 검색 결과를 찾지 못했습니다.",
    );
  }
}

class SearchEmptyMessage extends StatelessWidget {
  const SearchEmptyMessage({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;

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
            Icon(icon, color: colors.textTertiary, size: 52),
            SizedBox(height: dimens.space4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 19,
                fontWeight: AppTypography.bold,
                height: 22 / 19,
              ),
            ),
            SizedBox(height: dimens.space3),
            Text(
              description,
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

class SearchResultList extends StatelessWidget {
  const SearchResultList({
    required this.query,
    required this.results,
    required this.favoriteSymbols,
    required this.onStockTap,
    required this.onFavoriteTap,
    super.key,
  });

  final String query;
  final List<Stock> results;
  final Set<String> favoriteSymbols;
  final ValueChanged<Stock> onStockTap;
  final ValueChanged<Stock> onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        final Stock stock = results[index];
        return SearchResultRow(
          stock: stock,
          query: query,
          isFavorite: favoriteSymbols.contains(stock.symbol),
          onTap: () => onStockTap(stock),
          onFavoriteTap: () => onFavoriteTap(stock),
        );
      },
    );
  }
}

class SearchResultRow extends StatelessWidget {
  const SearchResultRow({
    required this.stock,
    required this.query,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
    super.key,
  });

  final Stock stock;
  final String query;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

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
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 15,
                        fontWeight: AppTypography.medium,
                        height: 20 / 15,
                      ),
                      children: _highlightName(stock.name, query, colors),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    stock.symbolWithMarket,
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
            IconButton(
              onPressed: onFavoriteTap,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 44, height: 44),
              icon: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                color: isFavorite
                    ? colors.favoriteActive
                    : colors.favoriteInactive,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _highlightName(String name, String query, AppColors colors) {
    final int index = name.indexOf(query);
    if (query.isEmpty || index < 0) {
      return <TextSpan>[TextSpan(text: name)];
    }

    return <TextSpan>[
      if (index > 0) TextSpan(text: name.substring(0, index)),
      TextSpan(
        text: name.substring(index, index + query.length),
        style: TextStyle(color: colors.searchHighlight),
      ),
      if (index + query.length < name.length)
        TextSpan(text: name.substring(index + query.length)),
    ];
  }
}

const List<Stock> _searchStocks = sampleStocks;
