// ignore_for_file: body_might_complete_normally_nullable, prefer_const_constructors, unreachable_switch_case

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iam_training/constants/strings.dart';
import 'package:iam_training/logic/auth_cubit/auth_cubit.dart';
import 'package:iam_training/logic/phone_num_cubit/phone_cubit.dart';
import 'package:iam_training/presentation/screens/forgot_password.dart';
import 'package:iam_training/presentation/screens/home_screen.dart';
import 'package:iam_training/presentation/screens/login_screen.dart';
import 'package:iam_training/presentation/screens/signup_screen.dart';
import 'package:iam_training/presentation/screens/verify.dart';

class AppRouter {
  AuthCubit? authCubit;
  PhoneCubit? phoneCubit;

  AppRouter() {
    authCubit = AuthCubit();
    phoneCubit = PhoneCubit();
  }

  Route? generationRoute(RouteSettings settings) {
    switch (settings.name) {
      case signUpScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<AuthCubit>.value(
                  value: authCubit!,
                  child: SignupScreen(),
                ));

      case loginScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<AuthCubit>.value(
                  value: authCubit!,
                  child: LoginScreen(),
                ));

      case forgotPasswordScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneCubit>.value(
                  value: phoneCubit!,
                  child: ForgotPassword(),
                ));

      case verifyScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneCubit>.value(
                  value: phoneCubit!,
                  child: VerifyScreen(phoneNumber: phoneNumber),
                ));

      case homeScreen:
        return MaterialPageRoute(builder: (context)=> HomeScreen());
    }
  }
}
