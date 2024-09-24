// ignore_for_file: body_might_complete_normally_nullable, prefer_const_constructors, unreachable_switch_case, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iam_training/constants/strings.dart';
import 'package:iam_training/logic/auth_cubit/auth_cubit.dart';
import 'package:iam_training/presentation/screens/confirm_password.dart';
import 'package:iam_training/presentation/screens/done_screen.dart';
import 'package:iam_training/presentation/screens/forgot_password.dart';
import 'package:iam_training/presentation/screens/home_screen.dart';
import 'package:iam_training/presentation/screens/login_screen.dart';
import 'package:iam_training/presentation/screens/signup_screen.dart';
import 'package:iam_training/presentation/screens/verify.dart';
import 'package:iam_training/presentation/screens/verify_forgot_password.dart';

class AppRouter {
  AuthCubit? authCubit;

  AppRouter() {
    authCubit = AuthCubit();
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
            builder: (_) => BlocProvider(
                  create: (BuildContext context)=> AuthCubit(),
                  child: LoginScreen(),
                ));

      case forgotPasswordScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<AuthCubit>.value(
                  value: authCubit!,
                  child: ForgotPassword(),
                ));

      case verifyScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider<AuthCubit>.value(
                  value: authCubit!,
                  child: VerifyScreen(phoneNumber: phoneNumber),
                ));

      case confirmPasswordScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<AuthCubit>.value(
                  value: authCubit!,
                  child: ConfirmPassword(),
                ));

      case verifyForgotPasswordScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider<AuthCubit>.value(
                  value: authCubit!,
                  child: VerifyForgotPassword(phoneNumber: phoneNumber),
                ));

      case doneScreen:
        return MaterialPageRoute(builder: (context) => DoneScreen());

      case homeScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<AuthCubit>.value(
                  value: authCubit!,
                  child: HomeScreen(),
                ));
    }
  }
}
