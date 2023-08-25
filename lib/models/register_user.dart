// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';
import 'show_snack_bar.dart';

Future<void> registerUser(
    {required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String confirmPassword}) async {
  CollectionReference users =
      FirebaseFirestore.instance.collection(kUsersCollection);

  if (password == confirmPassword) {
    var auth = FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(email: email, password: password);

    showSnackBar(
        context: context,
        text: 'Register Success',
        icon: Icons.check_circle,
        backColor: Colors.green);

    users.add({'email': email, 'name': name});

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  } else {
    showSnackBar(
        context: context,
        text: 'Password does\'t match',
        icon: Icons.no_encryption_gmailerrorred_rounded,
        backColor: Colors.red);
  }
}
