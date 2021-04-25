import 'package:flutter/material.dart';
import 'package:here_app/onboarding/login_page.dart';
import 'package:here_app/onboarding/register_page.dart';
import 'package:here_app/onboarding_widgets.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OnboardButton(
              fill: Colors.amber,
              text: "Sign Up!",
              onPressed: () {
                Navigator.pushNamed(context, RegisterPage.id);
              },
            ),
            OnboardButton(
              fill: Colors.white,
              text: "Sign In!",
              onPressed: () {
                Navigator.pushNamed(context, LoginPage.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
