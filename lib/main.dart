import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/data/http/auth_http.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/use_case/auth_use_case.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

import 'features/home/data/http/home_http.dart';
import 'features/home/domain/repository/home_repository.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/home_event.dart';

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

    final homeApiClient = HomeApiClient();
    final homeRepository = HomeRepositoryImpl(homeApiClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authUseCase)),
        BlocProvider(
          create: (_) => HomeBloc(homeRepository)..add(LoadHomeDataEvent()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852), // iPhone 14 Pro max size or standard
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Unique Food',
            theme: AppTheme.darkTheme,
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}
