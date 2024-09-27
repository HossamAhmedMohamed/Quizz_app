// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:iam_training/constants/colors.dart';

class ResultBox extends StatelessWidget {
  const ResultBox(
      {super.key,
      required this.result,
      required this.questionLength,
      required this.count,
      required this.restartQuiz});

  final int result;
  final int questionLength;
  final int count;
  final VoidCallback restartQuiz;

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
      child: AlertDialog(
        backgroundColor: background,
        content: Padding(
          padding: EdgeInsets.fromLTRB(widthScreen / 15, heightScreen / 15,
              widthScreen / 15, heightScreen / 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Result",
                style: TextStyle(color: natural, fontSize: 26,
                fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: heightScreen / 20,
              ),
              CircleAvatar(
                radius: 70,
                backgroundColor: count == questionLength
                    ? correct
                    : count < questionLength / 2
                        ? inCorrect
                        : count == questionLength / 2
                            ? Colors.yellow
                            : Colors.blueAccent,
                child: Text('$result/${questionLength * 10}', style: TextStyle(color: natural),),
              ),
              SizedBox(
                height: heightScreen / 20,
              ),
              Text(
                count == questionLength
                    ? "Great!"
                    : count < questionLength / 2
                        ? "Bad , Try again "
                        : "very good",
                style: TextStyle(
                    color: natural, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: heightScreen / 12,
              ),
              ElevatedButton(
                onPressed: restartQuiz,
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(50, 50),
                    backgroundColor: natural,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16))),
                child: Text(
                  "Restart Quiz ?",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
