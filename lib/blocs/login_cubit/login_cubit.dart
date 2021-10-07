import 'package:bloc/bloc.dart';

import '../../services/authentication.dart';

part 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(this._authentication) : super(LoginStateInitial());

  final Authentication _authentication;

  void sendOTP(String phone) async {
    try {
      await _authentication.sendOTP(phone);
      emit(LoginStateOTPSent());
    } catch (e) {
      emit(LoginStateError());
    }
  }

  void verifyOTP(String code) async {
    try {
      await _authentication.verifyOTP(code);
      emit(LoginStateVerified());
    } catch (e) {
      emit(LoginStateError());
    }
  }

  void signOut() async {
    try {
      await _authentication.signOut();
      emit(LoginStateInitial());
    } catch (e) {
      emit(LoginStateError());
    }
  }
}
