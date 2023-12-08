import 'package:akram/cubits/chat_cubit/chat_cubit.dart';
import 'package:akram/cubits/login_cubit/login_cubit.dart';
import 'package:akram/helper/shared_preferences.dart';
import 'package:akram/helper/show_snack_bar.dart';
import 'package:akram/screens/people_screen.dart';
import 'package:akram/screens/register_screen.dart';
import 'package:akram/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../widgets/text_field_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static String id = 'LoginScreen';

  String? email, password;

  bool isLoading = false;
  CacheData cacheData = CacheData();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoadingState) {
          isLoading = true;
        } else if (state is LoginSucsessState) {
          // BlocProvider.of<ChatCubit>(context)
          //     .getMessages(context: context, userEmail: email!);
          Navigator.pushNamed(context, PeopleScreen.id, arguments: email);
          isLoading = false;
        } else if (state is LoginFailureState) {
          showSnackBar(
              context: context,
              text: state.errMessage,
              icon: Icons.error,
              backColor: Colors.red);
          isLoading = false;
        }
      },
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          'Login',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
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
                      ButtonWidget(
                          text: 'Login',
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              BlocProvider.of<LoginCubit>(context).loginUser(
                                  context: context,
                                  email: email!,
                                  password: password!);
                            }
                          }),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('don\'t have an account? '),
                            GestureDetector(
                              onTap: () async {
                                Navigator.pushNamed(context, RegisterScreen.id);
                              },
                              child: const Text(
                                'Register',
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
      ),
    );
  }
}
