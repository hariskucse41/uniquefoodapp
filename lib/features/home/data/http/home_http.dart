import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
      return 'http://192.168.0.101:5000';
    }

    return 'http://192.168.0.101:5000';
  }

  Future<List<PromotionModel>> getHeroBanners() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/Promotions/hero'),
    );
    return _parseListResponse(
      response,
      (json) => PromotionModel.fromJson(json),
    );
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await _client.get(Uri.parse('$_baseUrl/api/Categories'));
    return _parseListResponse(response, (json) => CategoryModel.fromJson(json));
  }

  Future<List<PromotionModel>> getSpecialOffers() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/Promotions/special'),
    );
    return _parseListResponse(
      response,
      (json) => PromotionModel.fromJson(json),
    );
  }

  Future<List<ProductModel>> getPopularDishes() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/Products?isPopular=true'),
    );
    return _parseListResponse(response, (json) => ProductModel.fromJson(json));
  }

  Future<List<ProductModel>> getRecommendedDishes() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/Products?isRecommended=true'),
    );
    return _parseListResponse(response, (json) => ProductModel.fromJson(json));
  }

  Future<List<ProductModel>> getProducts({int? categoryId}) async {
    final url = categoryId != null
        ? '$_baseUrl/api/Products?categoryId=$categoryId'
        : '$_baseUrl/api/Products';
    final response = await _client.get(Uri.parse(url));
    return _parseListResponse(response, (json) => ProductModel.fromJson(json));
  }

  Future<List<dynamic>> getOrders(String status) async {
    // Note: Use the OrderModel returned format, but return raw dynamic for brevity,
    // or just return dynamic until we integrate the full model. Let's return raw json list for now.
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/Orders?status=$status'),
    );
    if ({200, 201}.contains(response.statusCode)) {
      final hasBody = response.body.trim().isNotEmpty;
      if (hasBody) {
        return jsonDecode(response.body) as List<dynamic>;
      }
    }
    return [];
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final response = await _client.get(Uri.parse('$_baseUrl/api/User/profile'));
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
}
