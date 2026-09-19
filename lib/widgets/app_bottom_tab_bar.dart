import 'package:flutter/material.dart';

import '../theme/theme.dart';

enum AppTab { watchlist, search }

class AppBottomTabBar extends StatelessWidget {
  const AppBottomTabBar({
    required this.selectedTab,
    this.onWatchlistTap,
    this.onSearchTap,
    super.key,
  });

  final AppTab selectedTab;
  final VoidCallback? onWatchlistTap;
  final VoidCallback? onSearchTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final double bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        border: Border(
          top: BorderSide(
            color: colors.borderSubtle,
            width: dimens.borderHairline,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 63,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: BottomTabItem(
                    label: '관심',
                    icon: selectedTab == AppTab.watchlist
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    selected: selectedTab == AppTab.watchlist,
                    onTap: onWatchlistTap,
                  ),
                ),
                Expanded(
                  child: BottomTabItem(
                    label: '검색',
                    icon: Icons.search_rounded,
                    selected: selectedTab == AppTab.search,
                    onTap: onSearchTap,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: bottomPadding > 0 ? bottomPadding : 34,
            child: Center(
              child: bottomPadding > 0
                  ? const SizedBox.shrink()
                  : Container(
                      width: 139,
                      height: 5,
                      decoration: BoxDecoration(
                        color: colors.textPrimary,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomTabItem extends StatelessWidget {
  const BottomTabItem({
    required this.label,
    required this.icon,
    required this.selected,
    this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final Color color = selected ? colors.navActive : colors.navInactive;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: color, size: 26),
            SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
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
