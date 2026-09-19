import 'package:flutter/material.dart';

import '../theme/theme.dart';

void showFavoriteSnackBar(
  BuildContext context, {
  required bool isFavorite,
  required double bottomMargin,
}) {
  final AppColors colors = context.colors;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.surfaceOverlay,
        elevation: 8,
        margin: EdgeInsets.fromLTRB(16, 0, 16, bottomMargin),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors.surfaceOverlay),
        ),
        duration: const Duration(milliseconds: 1400),
        content: Row(
          children: <Widget>[
            Icon(
              isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: isFavorite ? colors.favoriteActive : colors.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isFavorite ? '관심이 등록되었습니다' : '관심이 해제되었습니다',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 13,
                  fontWeight: AppTypography.bold,
                  height: 18 / 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
