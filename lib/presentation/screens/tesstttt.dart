// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpWithEmailAndPhonePage extends StatefulWidget {
  @override
  _SignUpWithEmailAndPhonePageState createState() => _SignUpWithEmailAndPhonePageState();
}

class _SignUpWithEmailAndPhonePageState extends State<SignUpWithEmailAndPhonePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String? verificationId;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUpWithEmail() async {
    try {
      // 1. تسجيل المستخدم بالإيميل والباسورد
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // 2. التحقق من رقم التليفون
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // التحقق التلقائي وربط رقم التليفون بالحساب
          await userCredential.user!.linkWithCredential(credential); // ربط الحساب برقم التليفون
          print("Phone number linked automatically.");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
          });
          print("Verification code sent to phone.");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Code retrieval timeout.");
        },
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _verifyAndLinkPhone() async {
    try {
      String smsCode = otpController.text;
      // إنشاء PhoneAuthCredential باستخدام الكود اللي المستخدم دخله
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );
      // ربط رقم التليفون بالحساب
      await _auth.currentUser!.linkWithCredential(credential);
      print("Phone number linked successfully.");
    } catch (e) {
      print("Error linking phone: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up with Email & Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUpWithEmail,
              child: Text('Sign Up'),
            ),
            if (verificationId != null) ...[
              TextField(
                controller: otpController,
                decoration: InputDecoration(labelText: 'Enter OTP'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyAndLinkPhone,
                child: Text('Verify & Link Phone'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
