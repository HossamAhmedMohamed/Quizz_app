// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unused_local_variable, use_build_context_synchronously, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iam_training/constants/strings.dart';
import 'package:iam_training/logic/auth_cubit/auth_cubit.dart';
import 'package:iam_training/presentation/widgets/image.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  bool isVisible = true;
  bool isLoading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Future<void> login(BuildContext context) async {
  //   if (!formKey.currentState!.validate()) {
  //     Navigator.pop(context);
  //     return;
  //   } else {
  //     Navigator.pop(context);
  //     formKey.currentState!.save();
  //     BlocProvider.of<AuthCubit>(context)
  //         .signIn(emailController, passwordController);
  //   }
  // }

  // Widget buildSignInWithEmailAndPassword() {
  //   return BlocListener<AuthCubit, AuthState>(

  //     listener: (context, state) {
  //       if (state is LoadingLogin) {
  //         showProgressIndicator(context);
  //       }
  //       if (state is SuccessfullyLoggedIn) {
  //         Navigator.pop(context);
  //       }
  //       if (state is ErrorOcurredforSignIn) {
  //         Navigator.pop(context);
  //         String errMsg = (state).errMsg;

  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text(errMsg),
  //           backgroundColor: Colors.black,
  //           duration: Duration(seconds: 5),
  //         ));
  //       }
  //     },
  //     child: Container(),
  //   );
  // }

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
                  if (value!.isEmpty) {
                    return "Please enter your email";
                  } else {
                    return null;
                  }
                }),
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your password";
                  } else {
                    return null;
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget buildForgotPassword() {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, forgotPasswordScreen);
        },
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.blueAccent, fontSize: 15),
        ));
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
        await signIn();
        if (!mounted) return;
      },
      child: Text(
        "Log in",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          backgroundColor: const Color.fromARGB(255, 23, 9, 108),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    );
  }

  signIn() async {
    Navigator.pop(context);
    setState(() {
      isLoading = true;
    });
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("donee"),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 5),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("user-not-found"),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 5),
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("wrong-password"),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 5),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("error"),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 5),
        ));
      }
    }
    setState(() {
      isLoading = false;
    });
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
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: widthScreen / 20, vertical: heightScreen / 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildImg(context),
              SizedBox(
                height: heightScreen / 20,
              ),
              buildTextField(),
              // SizedBox(
              //   height: heightScreen / 20,
              // ),
              Align(
                alignment: Alignment.centerRight,
                child: buildForgotPassword(),
              ),
              SizedBox(
                height: heightScreen / 30,
              ),

              buildButton(context),
              // buildSignInWithEmailAndPassword()
            ],
          ),
        ),
      ),
    ));
  }
}
