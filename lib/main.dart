import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/data/http/auth_http.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/use_case/auth_use_case.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const UniqueFoodApp());
}

class UniqueFoodApp extends StatelessWidget {
  const UniqueFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authApiClient = AuthApiClient();
    final authRepository = AuthRepositoryImpl(authApiClient);
    final authUseCase = AuthUseCase(authRepository);

    return BlocProvider(
      create: (_) => AuthBloc(authUseCase),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Unique Food',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
