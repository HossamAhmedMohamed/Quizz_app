// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:iam_training/constants/strings.dart';
import 'package:iam_training/presentation/widgets/congrats_img.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key});

  Widget buildIntroText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Congratulations",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 20,
        ),
        Text(
          "You have updated the password. please",
          style: TextStyle(fontSize: 18),
        ),
        Text(
          "login again with your latest password",
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

  Widget buildButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.pushReplacementNamed(context, loginScreen);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 20,
              vertical: MediaQuery.of(context).size.height / 25),
          child: Column(
            children: [
              buildCongratsImg(context),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              buildIntroText(context),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              buildButton(context)
            ],
          ),
        ),
      ),
    );
  }
}
