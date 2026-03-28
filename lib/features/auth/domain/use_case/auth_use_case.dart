import '../model/auth_login_result.dart';
import '../repository/auth_repository.dart';

class AuthUseCase {
  AuthUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthLoginResult> login({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }

  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.register(name: name, email: email, password: password);
  }
}
