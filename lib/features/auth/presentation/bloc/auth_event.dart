abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  LoginEvent({required this.email, required this.password});

  final String email;
  final String password;
}

class RegisterEvent extends AuthEvent {
  RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}

class ResetAuthEvent extends AuthEvent {}
