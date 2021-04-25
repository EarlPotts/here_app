import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:here_app/main.dart';
import 'package:logger/logger.dart';

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;
  static Logger l = Logger();

  static Future<bool> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        MyApp.showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        MyApp.showToast('The account already exists for that email.');
      }
    } catch (e) {
      Logger().d(e);
    }
    return false;
  }

  static Future<bool> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        MyApp.showToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        MyApp.showToast('Wrong password provided for that user.');
      }
    }
    return false;
  }

  static Future<bool> updateUserProfile(Map<String, dynamic> values) async {
    DocumentReference users = FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser?.uid}');

    users.update({'info': values}).then((value) {
      MyApp.showToast('Success!');
      return true;
    }).catchError((e) {
      MyApp.showToast(e.toString());
    });
    return false;
  }

  static Future<Map<String, String>?> getUserProfile() async {
    l.d("entered get profile");
    DocumentReference users = FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser?.uid}');

    users.get().then((snapshot) {
      if (snapshot.exists) {
        l.d(snapshot.get('info'));
        return snapshot.get('info');
      } else {
        l.e("Snapshot doesnt exist! ${snapshot.toString()}");
      }
    });

    return null;
  }
}
