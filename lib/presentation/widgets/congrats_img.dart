import 'package:flutter/material.dart';

Widget buildCongratsImg(BuildContext context) {
  return Center(
    child:  SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 4,
        child: Image.asset(
          "assets/images/Illustration_Congratulations.png",
           fit: BoxFit.cover,
        ),
      ),
    
  );
}
