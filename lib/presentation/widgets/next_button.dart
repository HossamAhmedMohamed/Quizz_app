// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iam_training/constants/colors.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key,});
   

  @override
  Widget build(BuildContext context) {
    return Container(
       width: MediaQuery.of(context).size.width/3,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color:  natural,
        borderRadius: BorderRadius.circular(16)
      ),
      child: Text(
        "Next",
        style: TextStyle(fontSize: 18 , color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}
