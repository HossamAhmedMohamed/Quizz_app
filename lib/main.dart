// ignore_for_file: unused_import, use_super_parameters

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iam_training/constants/strings.dart';
import 'package:iam_training/firebase_options.dart';
import 'package:iam_training/routing.dart';

late String initialRoute;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

    FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      initialRoute = signUpScreen;
    } else {
      initialRoute = homeScreen;
      // initialRoute = infoScreen;
    }
  });
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatelessWidget {
  const  MyApp({
    Key? key,
    required this.appRouter,
  }) : super(key: key);

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo_App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      onGenerateRoute: appRouter.generationRoute,
      initialRoute: signUpScreen,
      // home:
    );
  }
}
