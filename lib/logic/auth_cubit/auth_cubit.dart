// ignore_for_file: avoid_print, depend_on_referenced_packages, unused_local_variable

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> createEmailAndPassword(TextEditingController emailController,
      TextEditingController passwordController , ) async {
    emit(Loading());

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      emit(Submitted());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(ErrorOcurred(errMsg: e.code));
      } else if (e.code == 'email-already-in-use') {
        emit(ErrorOcurred(errMsg: e.code));
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<void> linkWithPhone(String verificationId, String smsCode) async {
  //   emit(Loading());

  //   try {
  //     // Create phone credential using the OTP
  //     PhoneAuthCredential phoneCredential = PhoneAuthProvider.credential(
  //       verificationId: verificationId,
  //       smsCode: smsCode,
  //     );

  //     // Link phone number with email user
  //     User? user = FirebaseAuth.instance.currentUser;
  //     await user?.linkWithCredential(phoneCredential);

  //     emit(SuccessfullyLinked());
  //     print("Phone number linked with email account successfully!");
  //   } on FirebaseAuthException catch (e) {
  //     print("Error linking phone number: ${e.message}");
  //     emit(ErrorOcurred(errMsg: e.code));
  //   }
  // }

  // Future<void> signIn(TextEditingController emailController,
  //     TextEditingController passwordController) async {
  //   emit(LoadingLogin());

  //   try {
  //     final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: emailController.text, password: passwordController.text);
  //     emit(SuccessfullyLoggedIn());
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       emit(ErrorOcurred(errMsg: e.code));
  //     } else if (e.code == 'wrong-password') {
  //       emit(ErrorOcurred(errMsg: e.code));
  //     }
  //     else{
  //       emit(ErrorOcurred(errMsg: "Something error....."));
  //     }
  //   }
  //   catch (e) {
  //   emit(ErrorOcurred(errMsg: e.toString()));
  // }
  // }
}
