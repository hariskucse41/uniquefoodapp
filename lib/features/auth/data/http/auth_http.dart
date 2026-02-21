import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthApiClient {
  AuthApiClient({http.Client? client}) : _client = client ?? http.Client();

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

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/Auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return _parseResponse(response, successCodes: {200});
  }

  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/Auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': name,
        'email': email,
        'password': password,
      }),
    );

    return _parseResponse(response, successCodes: {200, 201});
  }

  String _parseResponse(
    http.Response response, {
    required Set<int> successCodes,
  }) {
    final hasBody = response.body.trim().isNotEmpty;
    dynamic body;

    if (hasBody) {
      try {
        body = jsonDecode(response.body);
      } catch (_) {
        body = response.body;
      }
    }

    if (successCodes.contains(response.statusCode)) {
      if (body is Map<String, dynamic>) {
        return (body['message'] ?? body['token'] ?? 'Success').toString();
      }
      return body?.toString() ?? 'Success';
    }

    if (body is Map<String, dynamic>) {
      final message = body['message'] ?? body['error'] ?? body['title'];
      throw Exception(
        message?.toString() ?? 'Request failed: ${response.statusCode}',
      );
    }

    throw Exception(
      body?.toString() ??
          'Request failed with status code ${response.statusCode}',
    );
  }
}
