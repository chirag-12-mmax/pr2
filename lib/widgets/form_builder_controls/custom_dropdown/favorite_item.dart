import 'package:flutter/material.dart';
import 'package:onboarding_app/widgets/form_builder_controls/custom_dropdown/custom_dropdown_search.dart';

class FavoriteItemProps<T> {
  ///show or hide favorites items
  final bool showFavoriteItems;

  ///to customize favorites chips
  final FavoriteItemsBuilder<T>? favoriteItemBuilder;

  ///favorites items list
  final FavoriteItems<T>? favoriteItems;

  ///favorite items alignment
  final MainAxisAlignment favoriteItemsAlignment;

  const FavoriteItemProps({
    this.favoriteItemBuilder,
    this.favoriteItems,
    this.favoriteItemsAlignment = MainAxisAlignment.start,
    this.showFavoriteItems = false,
  });
}
