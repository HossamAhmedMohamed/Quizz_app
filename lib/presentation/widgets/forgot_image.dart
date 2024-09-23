import 'package:flutter/material.dart';

Widget buildForgotImg(BuildContext context) {
  return Center(
    child:  SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 4,
        child: Image.asset(
          "assets/images/Illustration_Forgot_Password_With_Phone.png",
           fit: BoxFit.cover,
        ),
      ),
    
  );
}
