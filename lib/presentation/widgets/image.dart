import 'package:flutter/material.dart';

Widget buildImg(BuildContext context) {
  return Center(
    child:  SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 4,
        child: Image.asset(
          "assets/images/pngegg.png",
          // fit: BoxFit.cover,
        ),
      ),
    
  );
}
