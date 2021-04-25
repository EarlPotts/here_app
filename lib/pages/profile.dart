import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:here_app/main.dart';
import 'package:here_app/onboarding/authentication.dart';
import 'package:here_app/onboarding_widgets.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:logger/logger.dart';

class ProfilePage extends StatefulWidget {
  static Map<String, dynamic> userInfo = {};
  final List<String> labels = [
    "Full name",
    "Email",
    "School Classification",
    "EID",
    "Pronouns",
    "Major"
  ];

  static String id = "profile";
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<SignInField> fields = [];
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> values = {};
  Map<String, dynamic>? initialValues;
  bool loading = true, gotData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialValues();
  }

  Future<void> getInitialValues() async {
    DocumentReference users = FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser?.uid}');

    users.get().then((snapshot) {
      if (snapshot.exists) {
        initialValues = snapshot.get('info');
        ProfilePage.userInfo = snapshot.get('info');
        fillValues(initialValues);
      } else {
        Logger().e("Snapshot doesnt exist! ${snapshot.toString()}");
      }
    });
  }

  Future<void> fillValues(Map<String, dynamic>? initialValues) async {
    Logger().d(initialValues);
    for (int i = 0; i < widget.labels.length; i++) {
      String field = widget.labels[i];
      fields.add(SignInField(
        validator: (value) {
          value = value ?? '';
          if (field == "Email") {
            if (!EmailValidator.validate(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          } else {
            if (value.length < 6) {
              return 'Please enter a valid ${field.toLowerCase()}.';
            }
            return null;
          }
        },
        onChanged: (String value) {
          setState(() {
            values[field] = value;
          });
        },
        obscure: false,
        hint: 'Enter your ${field.toLowerCase()}',
        isLast: field == "Major",
        inputType:
            field == "Email" ? TextInputType.emailAddress : TextInputType.text,
        initialText: initialValues == null ? '' : initialValues?[field],
      ));
    }
    values.addAll(initialValues ?? {});
    Logger().d(values.toString());
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: LoadingFlipping.square());
    }
    List<Widget> columnWidgets = [];
    columnWidgets.addAll(fields);
    columnWidgets.add(OnboardButton(
      fill: Colors.amber,
      text: 'Update Profile',
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await Authentication.updateUserProfile(values);
        }
      },
    ));

    return Container(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: columnWidgets,
          ),
        ),
      ),
    );
  }
}
