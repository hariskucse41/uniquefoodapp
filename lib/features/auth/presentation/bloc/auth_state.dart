enum AuthStatus { initial, loading, loginSuccess, registerSuccess, failure }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.message,
    this.userName,
    this.userEmail,
  });

  final AuthStatus status;
  final String? message;
  final String? userName;
  final String? userEmail;

  AuthState copyWith({
    AuthStatus? status,
    String? message,
    String? userName,
    String? userEmail,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}
