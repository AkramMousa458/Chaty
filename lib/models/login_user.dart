// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:akram/models/show_snack_bar.dart';
import 'package:akram/screens/people_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> loginUser({
  required BuildContext context,
  required String email,
  required String password,
}) async {
  try {
    var auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(email: email, password: password);
    Navigator.pushNamed(context, PeopleScreen.id, arguments: email);
  } on FirebaseAuthException catch (ex) {
    if (ex.code == 'user-not-found') {
      showSnackBar(
          context: context,
          text: 'No user found for that email.',
          icon: Icons.error,
          backColor: Colors.red);
    } else if (ex.code == 'wrong-password') {
      showSnackBar(
          context: context,
          text: 'Wrong password',
          icon: Icons.error,
          backColor: Colors.red);
    }
  } catch (ex) {
    // ignore: avoid_print
    print(ex);
  }
}
