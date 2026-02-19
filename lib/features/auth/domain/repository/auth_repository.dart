import '../../data/http/auth_http.dart';

abstract class AuthRepository {
  Future<String> login({required String email, required String password});

  Future<String> register({
    required String name,
    required String email,
    required String password,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._apiClient);

  final AuthApiClient _apiClient;

  @override
  Future<String> login({required String email, required String password}) {
    return _apiClient.login(email: email, password: password);
  }

  @override
  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _apiClient.register(name: name, email: email, password: password);
  }
}
