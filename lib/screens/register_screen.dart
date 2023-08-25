// ignore_for_file: depend_on_referenced_packages

import 'package:akram/models/register_user.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/show_snack_bar.dart';
import '../widgets/button_widget.dart';
import '../widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static String id = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? name, email, password, confirmPassword;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(backgroundColor: kPrimaryColor, elevation: 0),
        backgroundColor: kPrimaryColor,
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      kLogo,
                      width: 120,
                    ),
                    const Text(
                      'Chaty',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    FormTextFieldWidget(
                      onChanged: (data) {
                        name = data;
                      },
                      hintText: 'Full name',
                      isPassword: false,
                      icon: const Icon(Icons.drive_file_rename_outline_rounded),
                    ),
                    const SizedBox(height: 16),
                    FormTextFieldWidget(
                      hintText: 'Email',
                      isPassword: false,
                      icon: const Icon(Icons.alternate_email_rounded),
                      onChanged: (data) {
                        email = data;
                      },
                    ),
                    const SizedBox(height: 16),
                    FormTextFieldWidget(
                      hintText: 'Password',
                      isPassword: true,
                      icon: const Icon(Icons.password_rounded),
                      onChanged: (data) {
                        password = data;
                      },
                    ),
                    const SizedBox(height: 16),
                    FormTextFieldWidget(
                      hintText: 'Confirm your password',
                      isPassword: true,
                      icon: const Icon(Icons.password_rounded),
                      onChanged: (String data) {
                        confirmPassword = data;
                      },
                    ),
                    ButtonWidget(
                        text: 'Register',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await registerUser(
                                  context: context,
                                  name: name.toString(),
                                  email: email.toString(),
                                  password: password.toString(),
                                  confirmPassword: confirmPassword.toString());
                              setState(() {
                                isLoading = false;
                              });
                            } on FirebaseAuthException catch (ex) {
                              if (ex.code == 'weak-password') {
                                showSnackBar(
                                    context: context,
                                    text: 'The password is too weak.',
                                    icon: Icons.no_encryption_gmailerrorred,
                                    backColor: Colors.red);
                              } else if (ex.code == 'email-already-in-use') {
                                showSnackBar(
                                    context: context,
                                    text:
                                        'The account already exists for that email.',
                                    icon: Icons.no_encryption_gmailerrorred,
                                    backColor: Colors.red,
                                    textSize: 15);
                              }
                            } catch (ex) {
                              showSnackBar(
                                context: context,
                                text: 'Error, Please try again.',
                                icon: Icons.no_encryption_gmailerrorred,
                                backColor: Colors.red,
                              );
                            }
                          } else {}
                        }),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('already have an account? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
