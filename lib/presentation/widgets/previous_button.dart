// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iam_training/constants/colors.dart';

class PreviousButton extends StatelessWidget {
  const PreviousButton({super.key, required this.backQuestion});
  final VoidCallback backQuestion;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: backQuestion,
      style: ElevatedButton.styleFrom(
          minimumSize: Size( MediaQuery.of(context).size.height/6, 46),
          backgroundColor: natural,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      child: Text(
        "Back",
        style: TextStyle(fontSize: 18 , color: Colors.black),
      ),
    );
  }
}
