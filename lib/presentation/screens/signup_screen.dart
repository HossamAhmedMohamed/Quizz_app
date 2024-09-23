// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iam_training/constants/strings.dart';
import 'package:iam_training/logic/auth_cubit/auth_cubit.dart';
import 'package:iam_training/presentation/widgets/image.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isVisible = true;

  bool isPassword8Char = false;
  bool isPasswordHas1Number = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;

  onPasswordChanged(String password) {
    isPassword8Char = false;
    isPasswordHas1Number = false;
    hasUppercase = false;
    hasLowercase = false;
    hasSpecialCharacters = false;

    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        isPassword8Char = true;
      }

      if (password.contains(RegExp(r'[0-9]'))) {
        isPasswordHas1Number = true;
      }

      if (password.contains(RegExp(r'[A-Z]'))) {
        hasUppercase = true;
      }

      if (password.contains(RegExp(r'[a-z]'))) {
        hasLowercase = true;
      }

      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hasSpecialCharacters = true;
      }
    });
  }

  Future<void> register(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      formKey.currentState!.save();
      BlocProvider.of<AuthCubit>(context)
          .createEmailAndPassword(emailController, passwordController);
    }
  }

  Widget buildSubmittedEmailAndPassword() {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Loading) {
          showProgressIndicator(context);
        }
        if (state is Submitted) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, loginScreen);
        }

        if (state is ErrorOcurred) {
          Navigator.pop(context);
          String errMsg = (state).errMsg;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errMsg),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 5),
          ));
        }
      },
      child: Container(),
    );
  }

  Widget buildTextField() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.2),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: TextFormField(
              autofocus: true,
              controller: emailController,
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: "E-mail",
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value!.isNotEmpty &&
                    value.contains(RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                  return null;
                } else {
                  return "Enter a valid email";
                }
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.2),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: TextFormField(
              onChanged: (password) {
                onPasswordChanged(password);
              },
              obscureText: isVisible ? true : false,
              autofocus: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: passwordController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    icon: isVisible
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off)),
                hintText: "Password",
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                border: InputBorder.none,
              ),
              validator: (password) {
                if (password!.isNotEmpty && password.length > 8) {
                  return null;
                } else {
                  return "At least 8 characters";
                }
              },
            ),
          ),
        ],
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

  Widget buildButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        showProgressIndicator(context);
        register(context);
      },
      child: Text(
        "Sign up",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          backgroundColor: const Color.fromARGB(255, 23, 9, 108),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    );
  }

  Widget buildText() {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, loginScreen);
        },
        child: Text(
          "Already have account?",
          style: TextStyle(color: Colors.blueAccent, fontSize: 15),
        ));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: widthScreen / 20, vertical: heightScreen / 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildImg(context),
                SizedBox(
                  height: heightScreen / 20,
                ),
                buildTextField(),
                Align(
                  alignment: Alignment.centerRight,
                  child: buildText(),
                ),
                SizedBox(
                  height: heightScreen / 35,
                ),
                buildButton(context),
                buildSubmittedEmailAndPassword()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
