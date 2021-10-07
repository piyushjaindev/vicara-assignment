import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_cubit.dart';
import '../blocs/sensor_cubit/sensor_cubit.dart';
import '../services/websocket.dart';
import 'sensors_screen.dart';
import 'login_screens/login_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          switch (state) {
            case AuthState.unknown:
              return Center(child: CircularProgressIndicator());
            case AuthState.unauthenticated:
              return LoginScreen();
            case AuthState.authenticated:
              WebSocket _socket = WebSocket();
              return BlocProvider<SensorCubit>(
                  create: (context) => SensorCubit(_socket)..init(),
                  child: RepositoryProvider.value(
                      value: _socket, child: SensorsScreen()));
          }
        },
      ),
    );
  }
}
