// ignore_for_file: avoid_print, depend_on_referenced_packages, unused_local_variable, unused_element, unnecessary_import, prefer_const_constructors

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late String verificationId;
  late UserCredential userCredential;

  AuthCubit() : super(AuthInitial());

  Future<void> createEmailAndPassword(
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController phoneController,
  ) async {
    emit(Loading());

    try {
      // إنشاء حساب جديد باستخدام الإيميل والباسورد
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // التحقق من وجود ربط سابق لرقم التليفون
      bool isPhoneLinked = userCredential.user?.providerData.any(
            (info) => info.providerId == 'phone',
          ) ??
          false;

      if (!isPhoneLinked) {
        // لو رقم التليفون مش مربوط، نكمل عملية الربط
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+2${phoneController.text}',
          verificationCompleted: (PhoneAuthCredential credential) async {
            // ربط رقم التليفون بالحساب
            await userCredential.user!.linkWithCredential(credential);
            print("Phone number linked automatically.");
          },
          verificationFailed: (FirebaseAuthException e) {
            print("Verification failed: ${e.message}");
            emit(ErrorOcurred(errMsg: e.toString()));
          },
          codeSent: (String verificationId, int? resendToken) {
            this.verificationId = verificationId;
            emit(Submitted());
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print("Code retrieval timeout.");
          },
        );
      } else {
        print("Phone number already linked.");
        emit(SuccessfullyLinked());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(ErrorOcurred(errMsg: e.toString()));
      } else if (e.code == 'email-already-in-use') {
        emit(ErrorOcurred(errMsg: e.toString()));
      }
    } catch (e) {
      print(e);
      emit(ErrorOcurred(errMsg: e.toString()));
    }
  }

  Future<void> verifyAndLinkPhone(String otpCode) async {
    emit(Loading());
    try {
      String smsCode = otpCode;
      // إنشاء PhoneAuthCredential باستخدام الكود اللي المستخدم دخله
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      // ربط رقم التليفون بالحساب
      await FirebaseAuth.instance.currentUser!.linkWithCredential(credential);
      emit(SuccessfullyLinked());
      print("Phone number linked successfully.");
    } catch (e) {
      emit(ErrorOcurred(errMsg: e.toString()));
      print("Error linking phone: $e");
    }
  }

  Future<void> sendVerificationCode(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+2$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // لو حصل التحقق التلقائي (لو رقم التليفون متحقق منه قبل كده)
          // await logIn(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(ErrorOcurred(errMsg: e.toString()));
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          emit(PhoneNumberSubmitted());
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Code retrieval timeout.");
        },
      );
    } catch (e) {
      emit(ErrorOcurred(errMsg: e.toString()));
      print("Error: $e");
    }
  }

  // 2. التحقق من كود الـ OTP وتحديث الباسورد
  Future<void> submitOtp(String smsCode) async {
    emit(Loading());
    try {
      // إنشاء PhoneAuthCredential باستخدام الكود اللي المستخدم دخله
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // تسجيل الدخول باستخدام بيانات التحقق برقم التليفون (بدون ربط)
      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // دلوقتي تقدر تحدث الباسورد بدون محاولة الربط
      emit(PhoneOtpVerified());
    } catch (e) {
      emit(ErrorOcurred(errMsg: e.toString()));
      print("Error during OTP verification: $e");
    }
  }

  Future<void> resetPassword(
      TextEditingController newPasswordController) async {
    emit(Loading());
    try {
      // تحديث الباسورد بعد التحقق
      await userCredential.user!.updatePassword(newPasswordController.text);
      print("Password updated successfully.");

      // تسجيل خروج بعد تغيير الباسورد
      await FirebaseAuth.instance.signOut();
      emit(SuccessfullyUpdated());
      print("User signed out after password reset.");
    } catch (e) {
      emit(ErrorOcurred(errMsg: e.toString()));
      print("Error updating password: $e");
    }
  }

  Future<void> signInWithEmailAndPassword(TextEditingController emailController,
      TextEditingController passwordController) async {
    emit(Loading());

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      emit(SuccessfullyLoggedIn());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(ErrorOcurred(errMsg: e.toString()));
      } else if (e.code == 'wrong-password') {
        emit(ErrorOcurred(errMsg: e.toString()));
      } else {
        emit(ErrorOcurred(errMsg: e.toString()));
      }
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
