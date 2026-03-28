import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSession {
  const AuthSession({
    required this.token,
    required this.email,
    required this.expiresAtEpochMs,
  });

  final String token;
  final String email;
  final int expiresAtEpochMs;

  bool get isExpired =>
      DateTime.now().millisecondsSinceEpoch >= expiresAtEpochMs;
}

class AuthSessionStorage {
  AuthSessionStorage._();

  static final _prefs = SharedPreferencesAsync();

  static const _tokenKey = 'auth_token';
  static const _emailKey = 'auth_email';
  static const _expiresAtKey = 'auth_expires_at';

  // Fallback cache keeps auth flow working when plugin registration fails
  // (e.g., hot-restart after adding plugin). Persistence resumes automatically
  // once shared_preferences becomes available.
  static final Map<String, Object> _memoryFallback = {};

  static Future<void> saveSession({
    required String token,
    required String email,
    Duration validFor = const Duration(days: 3),
  }) async {
    final expiresAt = DateTime.now().add(validFor).millisecondsSinceEpoch;

    _memoryFallback[_tokenKey] = token;
    _memoryFallback[_emailKey] = email;
    _memoryFallback[_expiresAtKey] = expiresAt;

    try {
      await _prefs.setString(_tokenKey, token);
      await _prefs.setString(_emailKey, email);
      await _prefs.setInt(_expiresAtKey, expiresAt);
    } on MissingPluginException catch (error) {
      debugPrint('AuthSessionStorage.saveSession fallback: $error');
    } on PlatformException catch (error) {
      debugPrint('AuthSessionStorage.saveSession platform fallback: $error');
    }
  }

  static Future<AuthSession?> readSession() async {
    String? token;
    String? email;
    int? expiresAt;

    try {
      token = await _prefs.getString(_tokenKey);
      email = await _prefs.getString(_emailKey);
      expiresAt = await _prefs.getInt(_expiresAtKey);
    } on MissingPluginException catch (error) {
      debugPrint('AuthSessionStorage.readSession fallback: $error');
    } on PlatformException catch (error) {
      debugPrint('AuthSessionStorage.readSession platform fallback: $error');
    }

    token ??= _memoryFallback[_tokenKey] as String?;
    email ??= _memoryFallback[_emailKey] as String?;
    expiresAt ??= _memoryFallback[_expiresAtKey] as int?;

    if (token == null || token.isEmpty || email == null || expiresAt == null) {
      return null;
    }

    return AuthSession(token: token, email: email, expiresAtEpochMs: expiresAt);
  }

  static Future<AuthSession?> readValidSession() async {
    final session = await readSession();

    if (session == null || session.isExpired) {
      await clearSession();
      return null;
    }

    return session;
  }

  static Future<String?> readValidToken() async {
    final session = await readValidSession();
    return session?.token;
  }

  static Future<void> clearSession() async {
    _memoryFallback.remove(_tokenKey);
    _memoryFallback.remove(_emailKey);
    _memoryFallback.remove(_expiresAtKey);

    try {
      await _prefs.remove(_tokenKey);
      await _prefs.remove(_emailKey);
      await _prefs.remove(_expiresAtKey);
    } on MissingPluginException catch (error) {
      debugPrint('AuthSessionStorage.clearSession fallback: $error');
    } on PlatformException catch (error) {
      debugPrint('AuthSessionStorage.clearSession platform fallback: $error');
    }
  }
}
