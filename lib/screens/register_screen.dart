// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:akram/models/register_user.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/show_snack_bar.dart';
import '../widgets/button_widget.dart';
import '../widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static String id = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? name, email, password, confirmPassword, statues;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  File? _image;
  String imageUrl = '';

  void selectImage() async {
    try {
      //select image from device
      ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

      if (file == null) return;

      setState(() {
        _image = File(file.path);
      });

      //upload to firebase
      final String uniqueFileName =
          DateTime.now().millisecondsSinceEpoch.toString();

      final Reference referenceRoot = FirebaseStorage.instance.ref();
      final referenceDirImages = referenceRoot.child('images');
      final referenceImageToUpload = referenceDirImages.child(uniqueFileName);

      try {
        await referenceImageToUpload.putFile(File(file.path));
        imageUrl = await referenceImageToUpload.getDownloadURL();
        print('Image uploaded!');
      } catch (error) {
        print('Image not uploaded');
      }
    } catch (ex) {
      showSnackBar(
          context: context,
          text: 'No image selected',
          icon: Icons.image_not_supported_rounded,
          backColor: Colors.blueGrey);
    }
  }

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
                    Stack(
                      children: [
                        _image == null
                            ? GestureDetector(
                                onTap: () async {
                                  selectImage();
                                },
                                child: const CircleAvatar(
                                  radius: 65,
                                  backgroundImage:
                                      AssetImage('assets/images/user.png'),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  selectImage();
                                },
                                child: CircleAvatar(
                                  radius: 65,
                                  backgroundImage: FileImage(_image as File),
                                ),
                              ),
                        Positioned(
                          bottom: -5,
                          right: -5,
                          child: IconButton(
                            onPressed: () async {
                              selectImage();
                            },
                            icon: const Icon(Icons.add_a_photo_rounded,
                                color: Colors.white),
                          ),
                        )
                      ],
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
                    const SizedBox(height: 16),
                    FormTextFieldWidget(
                      hintText: 'Ex: At work',
                      icon: Icon(Icons.text_fields_rounded),
                      isPassword: false,
                      onChanged: (String data) {
                        statues = data;
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
                                  email: email.toString().trim(),
                                  photoUrl: imageUrl.isEmpty
                                      ? 'https://firebasestorage.googleapis.com/v0/b/chaty-666cb.appspot.com/o/fixedPhoto%2Fuser.png?alt=media&token=2eed3132-bfb0-455c-bccb-99fccc023d16'
                                      : imageUrl,
                                  password: password.toString().trim(),
                                  confirmPassword:
                                      confirmPassword.toString().trim(),
                                  statues: statues.toString());
                              setState(() {
                                isLoading = false;
                              });
                            } on FirebaseAuthException catch (ex) {
                              if (ex.code == 'weak-password') {
                                setState(() {
                                  isLoading = false;
                                });
                                showSnackBar(
                                    context: context,
                                    text: 'The password is too weak.',
                                    icon: Icons.no_encryption_gmailerrorred,
                                    backColor: Colors.red);
                              } else if (ex.code == 'email-already-in-use') {
                                setState(() {
                                  isLoading = false;
                                });
                                showSnackBar(
                                    context: context,
                                    text:
                                        'The account already exists for that email.',
                                    icon: Icons.no_encryption_gmailerrorred,
                                    backColor: Colors.red,
                                    textSize: 15);
                              }
                            } catch (ex) {
                              setState(() {
                                isLoading = false;
                              });
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
