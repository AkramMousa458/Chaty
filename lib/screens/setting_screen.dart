import 'dart:typed_data';

import 'package:akram/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  static String id = 'SettingScreen';

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Uint8List? image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.camera);
    setState(() {
      image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting', textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 65,
                        backgroundImage: AssetImage('assets/images/user.png'),
                      )
                    : CircleAvatar(
                        radius: 65,
                        backgroundImage: MemoryImage(image!),
                      ),
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: IconButton(
                    onPressed: () {
                      selectImage;
                    },
                    icon: const Icon(Icons.add_a_photo_rounded),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
