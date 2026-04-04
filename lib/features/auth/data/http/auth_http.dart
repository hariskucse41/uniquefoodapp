import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../domain/model/auth_login_result.dart';

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
      return 'http://192.168.0.105:5000';
    }

    return 'http://192.168.0.105:5000';
  }

  Future<AuthLoginResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/Auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _parseLoginResponse(response, successCodes: {200});
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

  AuthLoginResult _parseLoginResponse(
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

    if (!successCodes.contains(response.statusCode)) {
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

    if (body is Map<String, dynamic>) {
      final token = _extractToken(body);
      if (token == null || token.isEmpty) {
        throw Exception('Login succeeded but token was not returned by server');
      }

      final message = (body['message'] ?? body['status'] ?? 'Login successful')
          .toString();

      return AuthLoginResult(token: token, message: message);
    }

    if (body is String && _looksLikeJwt(body)) {
      return AuthLoginResult(token: body, message: 'Login successful');
    }

    throw Exception('Login succeeded but response format is invalid for token');
  }

  String? _extractToken(Map<String, dynamic> body) {
    final directCandidates = [
      body['token'],
      body['accessToken'],
      body['jwt'],
      body['idToken'],
    ];

    for (final candidate in directCandidates) {
      if (candidate is String && candidate.isNotEmpty) {
        return candidate;
      }
    }

    final data = body['data'];
    if (data is Map<String, dynamic>) {
      final nestedCandidates = [
        data['token'],
        data['accessToken'],
        data['jwt'],
        data['idToken'],
      ];
      for (final candidate in nestedCandidates) {
        if (candidate is String && candidate.isNotEmpty) {
          return candidate;
        }
      }
    }

    return null;
  }

  bool _looksLikeJwt(String value) {
    final parts = value.split('.');
    return parts.length == 3;
  }
}
