import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../auth/data/local/auth_session_storage.dart';
import '../../domain/models/extra_models.dart';
import '../../domain/models/home_models.dart';

class HomeApiClient {
  HomeApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _envBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  String get _baseUrl {
    if (_envBaseUrl.isNotEmpty) {
      return _envBaseUrl;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://192.168.0.105:5000';
    }

    return 'http://192.168.0.105:5000';
  }

  Future<List<PromotionModel>> getHeroBanners() async {
    final headers = await _buildAuthHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/Promotions/hero'),
      headers: headers,
    );
    return _parseListResponse(
      response,
      (json) => PromotionModel.fromJson(json),
    );
  }

  Future<List<CategoryModel>> getCategories() async {
    final headers = await _buildAuthHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/Categories'),
      headers: headers,
    );
    return _parseListResponse(response, (json) => CategoryModel.fromJson(json));
  }

  Future<List<PromotionModel>> getSpecialOffers() async {
    final headers = await _buildAuthHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/Promotions/special'),
      headers: headers,
    );
    return _parseListResponse(
      response,
      (json) => PromotionModel.fromJson(json),
    );
  }

  Future<List<ProductModel>> getPopularDishes() async {
    final headers = await _buildAuthHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/Products?isPopular=true'),
      headers: headers,
    );
    return _parseListResponse(response, (json) => ProductModel.fromJson(json));
  }

  Future<List<ProductModel>> getRecommendedDishes() async {
    final headers = await _buildAuthHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/Products?isRecommended=true'),
      headers: headers,
    );
    return _parseListResponse(response, (json) => ProductModel.fromJson(json));
  }

  Future<List<ProductModel>> getProducts({int? categoryId}) async {
    final url = categoryId != null
        ? '$_baseUrl/api/Products?categoryId=$categoryId'
        : '$_baseUrl/api/Products';
    final headers = await _buildAuthHeaders();
    final response = await _client.get(Uri.parse(url), headers: headers);
    return _parseListResponse(response, (json) => ProductModel.fromJson(json));
  }

  Future<List<dynamic>> getActiveOrders() async {
    final headers = await _buildAuthHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/Orders/active'),
      headers: headers,
    );

    return _parseDynamicListResponse(response);
  }

  Future<List<dynamic>> getOrderHistory() async {
    final headers = await _buildAuthHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/Orders/history'),
      headers: headers,
    );

    return _parseDynamicListResponse(response);
  }

  Future<void> createOrder(List<CreateOrderItemModel> items) async {
    final headers = await _buildAuthHeaders();
    headers['Content-Type'] = 'application/json';

    final response = await _client.post(
      Uri.parse('$_baseUrl/api/Orders'),
      headers: headers,
      body: jsonEncode({'items': items.map((item) => item.toJson()).toList()}),
    );

    if (!{200, 201}.contains(response.statusCode)) {
      final hasBody = response.body.trim().isNotEmpty;
      if (hasBody) {
        dynamic body;
        try {
          body = jsonDecode(response.body);
        } catch (_) {
          body = response.body;
        }

        if (body is Map<String, dynamic>) {
          final message = body['message'] ?? body['error'] ?? body['title'];
          throw Exception(
            message?.toString() ??
                'Failed to create order: status ${response.statusCode}',
          );
        }

        throw Exception(body.toString());
      }

      throw Exception('Failed to create order: status ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final headers = await _buildAuthHeaders();
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/User/profile'),
      headers: headers,
    );
    if ({200, 201}.contains(response.statusCode)) {
      final hasBody = response.body.trim().isNotEmpty;
      if (hasBody) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    }
    return null;
  }

  List<T> _parseListResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if ({200, 201}.contains(response.statusCode)) {
      final hasBody = response.body.trim().isNotEmpty;
      if (hasBody) {
        final List<dynamic> body = jsonDecode(response.body);
        return body.map((e) => fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    }

    throw Exception('Failed to load data, status code: ${response.statusCode}');
  }

  List<dynamic> _parseDynamicListResponse(http.Response response) {
    if ({200, 201}.contains(response.statusCode)) {
      final hasBody = response.body.trim().isNotEmpty;
      if (!hasBody) {
        return [];
      }

      final body = jsonDecode(response.body);
      if (body is List<dynamic>) {
        return body;
      }

      return [];
    }

    throw Exception(
      'Failed to load orders, status code: ${response.statusCode}',
    );
  }

  Future<Map<String, String>> _buildAuthHeaders() async {
    final token = await AuthSessionStorage.readValidToken();
    if (token == null || token.isEmpty) {
      return {};
    }

    return {'Authorization': 'Bearer $token'};
  }
}
