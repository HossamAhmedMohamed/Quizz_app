// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, avoid_unnecessary_containers, sort_child_properties_last, prefer_typing_uninitialized_variables, must_be_immutable, unused_import, unused_local_variable, non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iam_training/constants/strings.dart';
import 'package:iam_training/logic/auth_cubit/auth_cubit.dart';
import 'package:iam_training/presentation/screens/confirm_password.dart';
import 'package:iam_training/presentation/widgets/verify_image.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyForgotPassword extends StatelessWidget {
  VerifyForgotPassword({super.key, required this.phoneNumber});

  final phoneNumber;

  late String otpCode;

  Widget buildTextVerification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Please enter the 6 digit code",
          style: TextStyle(fontSize: 18),
        ),
        Container(
            // margin: EdgeInsets.symmetric(horizontal: 2),
            child: RichText(
                text: TextSpan(
                    text: "sent to ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        height: 1.4),
                    children: <TextSpan>[
              TextSpan(
                  text: "$phoneNumber", style: TextStyle(color: Colors.blue)),
            ])))
      ],
    );
  }

  Widget buildPhoneVerifiedBloc() {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, State) {
        if (State is Loading) {
          showProgressIndicator(context);
        }
        if (State is PhoneOtpVerified) {
          Navigator.pop(context);
          Navigator.of(context).pushReplacementNamed(confirmPasswordScreen);
        }
        if (State is ErrorOcurred) {
          Navigator.pop(context);
          String errorMsg = (State).errMsg;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 5),
          ));
        }
      },
      child: Container(),
    );
  }

  Widget buildPinCode(BuildContext context) {
    return Container(
      child: PinCodeTextField(
        appContext: context,
        autoFocus: true,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
        length: 6,
        obscureText: false,
        animationType: AnimationType.scale,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          borderWidth: 1,
          activeColor: Colors.blue,
          inactiveColor: Colors.blue,
          inactiveFillColor: Colors.white,
          activeFillColor: Colors.lightBlue,
          selectedColor: Colors.blue,
          selectedFillColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        enableActiveFill: true,
        onCompleted: (code) {
          otpCode = code;
          print("Completed");
        },
        onChanged: (value) {
          print(value);
        },
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return true;
        },
      ),
    );
  }

  void showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );
    showDialog(
        barrierColor: Colors.white.withOpacity(0),
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  void verify(BuildContext context) {
    BlocProvider.of<AuthCubit>(context).submitOtp(otpCode);
  }

  Widget buildButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        showProgressIndicator(context);
        verify(context);
      },
      child: Text(
        "Verify Code",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          backgroundColor: const Color.fromARGB(255, 23, 9, 108),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Verification Code"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: widthScreen / 20, vertical: heightScreen / 25),
            child: Column(
              children: [
                buildVerifyImg(context),
                SizedBox(
                  height: heightScreen / 20,
                ),
                buildTextVerification(),
                SizedBox(
                  height: heightScreen / 20,
                ),
                buildPinCode(context),
                SizedBox(
                  height: heightScreen / 20,
                ),
                buildButton(context),
                buildPhoneVerifiedBloc()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
