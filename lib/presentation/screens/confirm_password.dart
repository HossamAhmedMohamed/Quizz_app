// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iam_training/constants/strings.dart';
import 'package:iam_training/logic/auth_cubit/auth_cubit.dart';
import 'package:iam_training/presentation/widgets/confirm_password_image.dart';

class ConfirmPassword extends StatefulWidget {
  const ConfirmPassword({super.key});

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  GlobalKey<FormState> formKey = GlobalKey();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isVisible = true;


  Widget buildIntroText() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "New password must be",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            "different from last password",
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }

  Widget buildTextField() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password",
            style: TextStyle(fontSize: 15),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.2),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: TextFormField(
              obscureText: isVisible ? true : false,
              autofocus: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: passwordController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    icon: isVisible
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off)),
                // hintText: "Confirm Password",
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
          SizedBox(
            height: 30,
          ),
          Text(
            "Confirm Password",
            style: TextStyle(fontSize: 15),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.2),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: TextFormField(
              obscureText: isVisible ? true : false,
              autofocus: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: confirmPasswordController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    icon: isVisible
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off)),
                // hintText: "Confirm Password",
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

  Widget buildResetPasswordbloC() {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is Loading) {
          showProgressIndicator(context);
        }

        if (state is SuccessfullyUpdated) {
          Navigator.pop(context);
          Navigator.of(context).pushReplacementNamed(doneScreen);
        }

        if (state is ErrorOcurred) {
          String errorMsg = (state).errMsg;
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

  Future<void> resetPassword(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      if (passwordController.text == confirmPasswordController.text) {
        Navigator.pop(context);
        formKey.currentState!.save();
        BlocProvider.of<AuthCubit>(context)
            .resetPassword(confirmPasswordController);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Something error..."),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 5),
        ));
      }
    }
  }

  Widget buildButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        showProgressIndicator(context);
        resetPassword(context);
      },
      child: Text(
        "Save Password",
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
          title: Text("Create New Password"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: widthScreen / 20, vertical: heightScreen / 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildConfirmImg(context),
                SizedBox(
                  height: heightScreen / 20,
                ),
                buildIntroText(),
                SizedBox(
                  height: heightScreen / 20,
                ),
                buildTextField(),
                SizedBox(
                  height: heightScreen / 20,
                ),
                buildButton(context),
                buildResetPasswordbloC()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
