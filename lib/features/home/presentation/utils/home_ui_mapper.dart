import 'package:flutter/material.dart';

import '../../domain/models/home_models.dart';

class HomeUiMapper {
  HomeUiMapper._();

  static Color parseColor(String? colorStr, Color defaultColor) {
    if (colorStr == null || colorStr.isEmpty) {
      return defaultColor;
    }

    try {
      String hex = colorStr.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return defaultColor;
    }
  }

  static IconData iconFromName(String? iconName) {
    switch (iconName) {
      case 'local_pizza':
        return Icons.local_pizza;
      case 'ramen_dining':
        return Icons.ramen_dining;
      case 'bakery_dining':
        return Icons.bakery_dining;
      case 'local_cafe':
        return Icons.local_cafe;
      case 'icecream':
        return Icons.icecream;
      case 'lunch_dining':
        return Icons.lunch_dining;
      case 'family_restroom':
        return Icons.family_restroom;
      case 'brunch_dining':
        return Icons.brunch_dining;
      case 'local_bar':
        return Icons.local_bar;
      case 'cake':
        return Icons.cake;
      case 'eco':
        return Icons.eco;
      case 'set_meal':
        return Icons.set_meal;
      default:
        return Icons.fastfood;
    }
  }

  static Color colorFromCategoryId(
    int categoryId,
    List<CategoryModel> categories,
    Color defaultColor,
  ) {
    for (final category in categories) {
      if (category.id == categoryId) {
        return parseColor(category.color, defaultColor);
      }
    }

    return defaultColor;
  }

  static IconData iconFromCategoryId(
    int categoryId,
    List<CategoryModel> categories,
  ) {
    for (final category in categories) {
      if (category.id == categoryId) {
        return iconFromName(category.iconName);
      }
    }

    return iconFromName(null);
  }
}
