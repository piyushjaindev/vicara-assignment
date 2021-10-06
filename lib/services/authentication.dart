import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String _verificationCode;
  int? _forceResendingToken;

  Stream<User?> get user => _auth.authStateChanges();

  Future<void> sendOTP(String phone) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phone',
        verificationCompleted: (credential) =>
            _auth.signInWithCredential(credential),
        verificationFailed: (e) {
          throw e;
        },
        codeSent: (verificationCode, resendCode) {
          _verificationCode = verificationCode;
          _forceResendingToken = resendCode;
        },
        timeout: Duration(seconds: 120),
        codeAutoRetrievalTimeout: (verificationCode) {
          _verificationCode = verificationCode;
        },
        forceResendingToken: _forceResendingToken,
      );
    } on Exception {
      rethrow;
    }
  }

  Future<void> verifyOTP(String code) async {
    try {
      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: _verificationCode, smsCode: code);

      await _auth.signInWithCredential(authCredential);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw e;
    }
  }
}
