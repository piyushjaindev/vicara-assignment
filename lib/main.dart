import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/main_screen.dart';
import 'blocs/auth_cubit.dart';
import 'blocs/login_cubit/login_cubit.dart';
import 'services/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Authentication _authentication = Authentication();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(_authentication)..init(),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(_authentication),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(),
      ),
    );
  }
}
