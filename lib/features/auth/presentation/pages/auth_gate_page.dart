import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/local/auth_session_storage.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import 'login_page.dart';
import '../../../home/presentation/pages/home_shell.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthSession?>(
      future: AuthSessionStorage.readValidSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data;
        if (session == null) {
          return const LoginPage();
        }

        context.read<AuthBloc>().add(
          RestoreSessionEvent(email: session.email, token: session.token),
        );
        return const HomeShell();
      },
    );
  }
}
