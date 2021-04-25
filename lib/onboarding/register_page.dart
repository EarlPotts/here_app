import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:here_app/onboarding/authentication.dart';
import 'package:logger/logger.dart';

import '../onboarding_widgets.dart';

class RegisterPage extends StatefulWidget {
  static String id = "register";

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';
  Logger l = Logger();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create an account"),
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignInField(
                hint: "Email",
                obscure: false,
                isLast: false,
                inputType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                validator: (String? value) {
                  value = value ?? '';
                  if (!EmailValidator.validate(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SignInField(
                hint: "Password",
                obscure: true,
                isLast: true,
                inputType: TextInputType.text,
                onChanged: (value) {
                  password = value;
                },
                validator: (String? value) {
                  value = value ?? '';
                  if (value.length < 6) {
                    return 'Please enter at least 6 characters';
                  }
                  return null;
                },
              ),
              OnboardButton(
                fill: Colors.yellow,
                text: "Register",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await Authentication.signUp(email, password);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
