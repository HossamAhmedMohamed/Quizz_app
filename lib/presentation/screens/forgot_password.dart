// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, sort_child_properties_last, avoid_unnecessary_containers, non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iam_training/constants/strings.dart';
import 'package:iam_training/logic/auth_cubit/auth_cubit.dart';
import 'package:iam_training/presentation/widgets/forgot_image.dart';
import 'package:iam_training/presentation/widgets/image.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final GlobalKey<FormState> _phoneFormKey = GlobalKey();

  late String phoneNumber;
  final phoneController = TextEditingController();


  Future<void> register(BuildContext context) async {
    if (!_phoneFormKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      _phoneFormKey.currentState!.save();
      BlocProvider.of<AuthCubit>(context).sendVerificationCode(phoneNumber);
    }
  }

  Widget buildIntroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Please enter your phone number to",
          style: TextStyle(fontSize: 18),
        ),
        Text(
          "receive a verification code",
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

  

  Widget buildTextField() {
    return Form(
      key: _phoneFormKey,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.2),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: TextFormField(
          autofocus: true,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: phoneController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.mobile_friendly_rounded),
            hintText: "Please enter your number",
            hintStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter your number";
            } else if (value.length < 11) {
              return "Must be 11";
            }
            return null;
          },
          onSaved: (value) {
            phoneNumber = value!;
          },
        ),
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

  Widget buildPhoneNumberSubmittedBloc() {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, State) {
        if (State is Loading) {
          showProgressIndicator(context);
        }
        if (State is PhoneNumberSubmitted) {
          Navigator.pop(context);
          Navigator.of(context).pushNamed(verifyForgotPasswordScreen, arguments: phoneNumber);
        }
        if (State is ErrorOcurred) {
          Navigator.pop(context);
          String errorMsg = (State).errMsg;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 3),
          ));
        }
      },
      child: Container(),
    );
  }


  Widget buildButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        showProgressIndicator(context);
        register(context);
      },
      child: Text(
        "Send Code",
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
          title: Text("Forgot Password"),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: widthScreen / 20, vertical: heightScreen / 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildForgotImg(context),
                SizedBox(
                  height: heightScreen / 20,
                ),
                buildIntroText(),
                SizedBox(
                  height: heightScreen / 20,
                ),
                Text("Phone Number"),
                buildTextField(),
                SizedBox(
                  height: heightScreen / 25,
                ),
                buildButton(context),
                buildPhoneNumberSubmittedBloc()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
