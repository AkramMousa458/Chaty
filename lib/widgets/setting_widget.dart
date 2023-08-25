import 'package:flutter/material.dart';

class SettingWidget extends StatelessWidget {
  const SettingWidget({super.key});

  static String id = 'SettingScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting', textAlign: TextAlign.center),
        centerTitle: true,
      ),
    );
  }
}
