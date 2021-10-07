import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../blocs/login_cubit/login_cubit.dart';
import '../../services/notification.dart';

part 'enter_phone_screen.dart';
part 'enter_otp_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginStateOTPSent)
            NotificationService.showNotification(context, msg: 'OTP Sent!');
          else if (state is LoginStateVerified)
            NotificationService.showNotification(context, msg: 'OTP Verified!');
          else if (state is LoginStateError)
            NotificationService.showNotification(context);
        },
        buildWhen: (oldState, newState) =>
            newState is LoginStateInitial || newState is LoginStateOTPSent,
        builder: (context, state) {
          if (state is LoginStateOTPSent)
            return EnterOTPScreen();
          else
            return EnterPhoneScreen();
        },
      ),
    );
  }
}
