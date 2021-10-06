import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_cubit.dart';
import '../blocs/login_cubit/login_cubit.dart';
import 'sensors_screen.dart';
import 'login_screens/login_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          switch (state) {
            case AuthState.unknown:
              return Center(child: CircularProgressIndicator());
            case AuthState.unauthenticated:
              return LoginScreen();
            case AuthState.authenticated:
              return SensorsScreen();
          }
        },
      ),
    );
  }
}
