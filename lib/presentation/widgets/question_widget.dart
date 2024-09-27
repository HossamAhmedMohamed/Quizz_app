// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:iam_training/constants/colors.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget(
      {super.key,
      required this.question,
      required this.index,
      required this.totalQuestions});

  final String question;
  final int index;
  final int totalQuestions;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Text('Question ${index +1}',
          style: TextStyle(color: natural , fontSize: 22),),
          SizedBox(height: 7,),

          Text('$question' , style: TextStyle(color: natural , fontSize: 25, fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}
