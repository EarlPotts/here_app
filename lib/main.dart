import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_app/home_screen.dart';
import 'package:here_app/onboarding/login_page.dart';
import 'package:here_app/onboarding/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'onboarding/landing.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(child: Text("ERROR"));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          bool signedIn = FirebaseAuth.instance.currentUser != null;
          return MaterialApp(
            title: 'Here',
            theme: ThemeData(
              primarySwatch: Colors.amber,
            ),
            home: signedIn ? HomeScreen() : LandingPage(),
            routes: {
              RegisterPage.id: (context) => RegisterPage(),
              LoginPage.id: (context) => LoginPage(),
              HomeScreen.id: (context) => HomeScreen()
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text("ERROR");
      },
    );
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.amberAccent,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
