import 'package:akram/constants.dart';
import 'package:akram/models/message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/screen_args.dart';
import '../models/show_snack_bar.dart';
import '../widgets/message_bubble.dart';

// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  static String id = 'ChatScreen';

  TextEditingController messageController = TextEditingController();

  String? userMessage;

  final _controller = ScrollController();

  late List<Message> chat;

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);

  @override
  Widget build(BuildContext context) {
    ScreenArgs args = ModalRoute.of(context)!.settings.arguments as ScreenArgs;

    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy('time', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(
                Message.fromJson(snapshot.data!.docs[i]),
              );
            }
            chat = getChat(
                messagesList, args.userEmail, args.friendEmail, context);
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 22,
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset(kLogo, height: 38),
                          const SizedBox(width: 6),
                          Text(args.friendName)
                        ],
                      ),
                      Container(width: 30)
                    ],
                  ),
                  backgroundColor: kPrimaryColor,
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        controller: _controller,
                        itemCount: chat.length,
                        itemBuilder: (context, index) {
                          return chat[index].id == args.userEmail &&
                                  chat[index].friendId == args.friendEmail
                              ? GestureDetector(
                                  onLongPress: () {
                                    showSnackBar(
                                        context: context,
                                        text: chat[index].text,
                                        icon: Icons.message,
                                        backColor: Colors.grey);
                                  },
                                  child:
                                      MessageBubbleSend(message: chat[index]))
                              : MessageBubbleReceive(message: chat[index]);
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: messageController,
                                onChanged: (data) {
                                  userMessage = data;
                                },
                                onSubmitted: (data) {
                                  if (data != '') {
                                    messages.add({
                                      kMessage: data,
                                      kTime: getTime(
                                        DateTime.now().hour,
                                        DateTime.now().minute,
                                        DateTime.now().second,
                                        DateTime.now().millisecond,
                                      ),
                                      kCreatedAt: DateTime.now(),
                                      kId: args.userEmail,
                                      kFriendId: args.friendEmail
                                    });
                                  }
                                  messageController.clear();
                                  userMessage = null;
                                  _controller.animateTo(0 - 80,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.fastOutSlowIn);
                                },
                                style: const TextStyle(fontSize: 18),
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  hintText: 'Message',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(200),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (userMessage != null) {
                                  messages.add({
                                    kMessage: userMessage,
                                    kTime: getTime(
                                        DateTime.now().hour,
                                        DateTime.now().minute,
                                        DateTime.now().second,
                                        DateTime.now().millisecond),
                                    kCreatedAt: DateTime.now(),
                                    kId: args.userEmail,
                                    kFriendId: args.friendEmail
                                  });
                                }
                                userMessage = null;
                                messageController.clear();
                                _controller.animateTo(0 - 40,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                margin: const EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Icon(
                                  Icons.send_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ))
                  ],
                ));
          } else {
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(kLogo, height: 38),
                      const SizedBox(width: 6),
                      const Text('Chaty')
                    ],
                  ),
                  backgroundColor: kPrimaryColor,
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Waiting to load messages..',
                          style: TextStyle(
                            fontSize: 18,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            const Expanded(
                              child: TextField(
                                style: TextStyle(fontSize: 18),
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: 'Message',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(200),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                margin: const EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Icon(
                                  Icons.send_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ))
                  ],
                ));
          }
        });
  }

  List<Message> getChat(List<Message> list, String sender, String receiver,
      BuildContext context) {
    List<Message> chat = [];
    for (int i = 0; i < list.length; i++) {
      if ((list[i].id == sender && list[i].friendId == receiver) ||
          list[i].friendId == sender && list[i].id == receiver) {
        chat.add(list[i]);
      }
    }
    return chat;
  }

  String getTime(var hour, var minute, var second, var millisecond) {
    String getHour, getMinute, getSecond, getMilliSecond;

    hour < 10 ? getHour = '0$hour' : getHour = '$hour';

    minute < 10 ? getMinute = '0$minute' : getMinute = '$minute';

    second < 10 ? getSecond = '0$second' : getSecond = '$second';

    millisecond < 10
        ? getMilliSecond = '0$millisecond'
        : getMilliSecond = '$millisecond';

    return '$getHour:$getMinute:$getSecond:$getMilliSecond';
  }
}
