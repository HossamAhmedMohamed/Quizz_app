// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iam_training/constants/strings.dart';
import 'package:iam_training/logic/auth_cubit/auth_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber,

        body: Center(
          child: ElevatedButton(onPressed: () async{
            await BlocProvider.of<AuthCubit>(context).logOut();
            Navigator.of(context).pushReplacementNamed(loginScreen);
          }, child: Text("Log out") ),
        ),
      ),
    );
  }
}