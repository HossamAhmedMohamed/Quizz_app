// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class OptionsCard extends StatelessWidget {
  const OptionsCard({super.key, required this.options, required this.color,});
  final String options;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
        title: Text(
          options,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22,
          
          // color: color.red != color.green ?   Colors.black : natural 
          ),
        ),
      ),
    );
  }
}
