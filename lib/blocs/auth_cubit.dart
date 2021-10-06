import 'dart:async';

import 'package:bloc/bloc.dart';

import '../services/authentication.dart';

enum AuthState { unknown, unauthenticated, authenticated }

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.unknown);

  late StreamSubscription _authStateListener;

  final Authentication authentication = Authentication();

  @override
  Future<void> close() async {
    _authStateListener.cancel();
    return super.close();
  }

  void init() {
    _authStateListener = authentication.user.listen((currentUser) {
      if (currentUser == null)
        emit(AuthState.unauthenticated);
      else
        emit(AuthState.authenticated);
    });
  }
}
