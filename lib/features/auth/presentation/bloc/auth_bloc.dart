import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_case/auth_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authUseCase) : super(const AuthState()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<ResetAuthEvent>(_onReset);
  }

  final AuthUseCase _authUseCase;

  void _onReset(ResetAuthEvent event, Emitter<AuthState> emit) {
    emit(const AuthState());
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    try {
      final message = await _authUseCase.login(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: AuthStatus.success, message: message));
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    try {
      final message = await _authUseCase.register(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: AuthStatus.success, message: message));
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
