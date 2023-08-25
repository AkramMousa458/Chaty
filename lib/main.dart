// ignore_for_file: depend_on_referenced_packages

import 'package:akram/screens/home_screen.dart';
import 'package:akram/screens/login_screen.dart';
import 'package:akram/screens/register_screen.dart';
import 'package:akram/screens/chat_screen.dart';

import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Chaty());
}

class Chaty extends StatelessWidget {
  const Chaty({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // builder: DevicePreview.appBuilder,
      title: 'Chaty',
      debugShowCheckedModeBanner: false,
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
      theme: ThemeData(
          fontFamily: 'Cairo',
          textTheme:
              const TextTheme(bodyMedium: TextStyle(color: Colors.white))),
      initialRoute: LoginScreen.id,
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(DevicePreview(builder: (context) => const Chaty()));
// }
//
// class Chaty extends StatelessWidget {
//   const Chaty({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Chaty',
//       builder: DevicePreview.appBuilder,
//       debugShowCheckedModeBanner: false,
//       routes: {
//         LoginScreen.id: (context) => const LoginScreen(),
//         HomeScreen.id: (context) => const HomeScreen(),
//         RegisterScreen.id: (context) => const RegisterScreen(),
//       },
//       theme: ThemeData(
//           fontFamily: 'Cairo',
//           textTheme:
//               const TextTheme(bodyMedium: TextStyle(color: Colors.white))),
//       initialRoute: LoginScreen.id,
//     );
//   }
// }
