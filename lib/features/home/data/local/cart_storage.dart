import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CartStorage {
  static const String _cartKey = 'menu_cart_quantities_v1';

  static Future<Map<int, int>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cartKey);

    if (raw == null || raw.trim().isEmpty) {
      return <int, int>{};
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return <int, int>{};
      }

      final result = <int, int>{};
      decoded.forEach((key, value) {
        final parsedKey = int.tryParse(key);
        final quantity = value is num ? value.toInt() : int.tryParse('$value');
        if (parsedKey != null && quantity != null && quantity > 0) {
          result[parsedKey] = quantity;
        }
      });

      return result;
    } catch (_) {
      return <int, int>{};
    }
  }

  static Future<void> save(Map<int, int> cartQuantities) async {
    final prefs = await SharedPreferences.getInstance();

    final serializable = <String, int>{};
    cartQuantities.forEach((key, value) {
      if (value > 0) {
        serializable['$key'] = value;
      }
    });

    if (serializable.isEmpty) {
      await prefs.remove(_cartKey);
      return;
    }

    await prefs.setString(_cartKey, jsonEncode(serializable));
  }
}
