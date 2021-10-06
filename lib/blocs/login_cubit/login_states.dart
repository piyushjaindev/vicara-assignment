part of 'login_cubit.dart';

abstract class LoginStates {}

class LoginStateInitial extends LoginStates {}

class LoginStateOTPSent extends LoginStates {}

class LoginStateVerified extends LoginStates {}

class LoginStateError extends LoginStates {}
