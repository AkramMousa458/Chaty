// ignore_for_file: depend_on_referenced_packages

import 'package:akram/constants.dart';
import 'package:akram/models/screen_args.dart';
import 'package:akram/models/user.dart';
import 'package:akram/screens/chat_screen.dart';
import 'package:akram/widgets/setting_widget.dart';
import 'package:akram/widgets/user_widget.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/find_user_name.dart';

class PeopleScreen extends StatelessWidget {
  PeopleScreen({super.key});

  static String id = 'PeopleScreen';

  final CollectionReference users =
      FirebaseFirestore.instance.collection(kUsersCollection);

  @override
  Widget build(BuildContext context) {
    String userEmail = ModalRoute.of(context)!.settings.arguments as String;

    return StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<User> usersList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              usersList.add(User.fromJson(snapshot.data!.docs[i]));
            }
            return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: kPrimaryColor,
                  ),
                  margin: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 120,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              image: const DecorationImage(
                                image: AssetImage('assets/images/user.png'),
                              ),
                              borderRadius: BorderRadius.circular(200)),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              findUserName(usersList, userEmail),
                              style: const TextStyle(
                                  color: Colors.black,
                                  height: 1.5,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text('At work',
                                style: TextStyle(
                                  color: Colors.black,
                                  height: 1.5,
                                  fontSize: 18,
                                ))
                          ],
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SettingWidget.id);
                      },
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.black,
                        size: 30,
                      ),
                    )
                  ],
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Chat',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                              topLeft: Radius.circular(25))),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: usersList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      ChatScreen.id,
                                      arguments: ScreenArgs(
                                          userEmail: userEmail,
                                          friendName: usersList[index].name,
                                          friendEmail: usersList[index].email),
                                    );
                                  },
                                  child: UserWidget(user: usersList[index]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Loading Chats'),
              ),
            );
          }
        });
  }
}
