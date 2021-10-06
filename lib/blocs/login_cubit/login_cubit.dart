import 'package:bloc/bloc.dart';

import '../../services/authentication.dart';

part 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginStateInitial());

  final Authentication authentication = Authentication();

  void sendOTP(String phone) async {
    try {
      await authentication.sendOTP(phone);
      emit(LoginStateOTPSent());
    } catch (e) {
      emit(LoginStateError());
    }
  }

  void verifyOTP(String code) async {
    try {
      await authentication.verifyOTP(code);
      emit(LoginStateVerified());
    } catch (e) {
      emit(LoginStateError());
    }
  }

  void signOut() async {
    try {
      await authentication.signOut();
      emit(LoginStateInitial());
    } catch (e) {
      emit(LoginStateError());
    }
  }
}
