// ignore_for_file: depend_on_referenced_packages

import 'package:akram/constants.dart';
import 'package:akram/models/message.dart';
import 'package:akram/widgets/confirm_dialog_box.dart';
import 'package:flutter/material.dart';

import '../models/screen_args.dart';
import '../utils.dart';
import '../widgets/message_bubble.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static String id = 'ChatScreen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  String? userMessage;

  final _controller = ScrollController();

  late List<Message> chat;

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);

  final soundPlayer = AudioPlayer();

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
                          size: 30,
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
                              ? Slidable(
                                  key: UniqueKey(),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: GestureDetector(
                                          onTap: () {
                                            String itemId =
                                                snapshot.data!.docs[index].id;
                                            setState(() {});
                                            confirmDialogBox(
                                                context: context,
                                                onTap: () async {
                                                  await deleteMessage(
                                                      messages, itemId);
                                                  Navigator.pop(context);
                                                },
                                                title: 'Delete Message',
                                                body:
                                                    'Do you want delete the message',
                                                no: 'Cancel',
                                                confirm: 'Delete');
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 19,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: GestureDetector(
                                          onTap: () {
                                            String itemId =
                                                snapshot.data!.docs[index].id;
                                            late String text = '';
                                            editDialogBox(
                                                context, text, index, itemId);

                                            setState(() {});
                                            // await updateMessage(itemId);
                                          },
                                          child: const Icon(
                                            Icons.edit_rounded,
                                            color: Colors.white,
                                            size: 19,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                      kMessage: data.trim(),
                                      kTime: getTime(
                                        DateTime.now().hour,
                                        DateTime.now().minute,
                                        DateTime.now().second,
                                        DateTime.now().millisecond,
                                        DateTime.now().day,
                                        DateTime.now().month,
                                        DateTime.now().year,
                                      ),
                                      kCreatedAt: DateTime.now(),
                                      kId: args.userEmail,
                                      kFriendId: args.friendEmail
                                    });
                                    _controller.animateTo(0,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.fastOutSlowIn);
                                    soundPlayer.play(AssetSource(
                                        'sounds/message_sound.mp3'));
                                  }
                                  messageController.clear();
                                  userMessage = null;
                                },
                                style: const TextStyle(fontSize: 18),
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
                                    kMessage: userMessage!.trim(),
                                    kTime: getTime(
                                      DateTime.now().hour,
                                      DateTime.now().minute,
                                      DateTime.now().second,
                                      DateTime.now().millisecond,
                                      DateTime.now().day,
                                      DateTime.now().month,
                                      DateTime.now().year,
                                    ),
                                    kCreatedAt: DateTime.now(),
                                    kId: args.userEmail,
                                    kFriendId: args.friendEmail
                                  });
                                  _controller.animateTo(0,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.fastOutSlowIn);
                                  soundPlayer.play(
                                      AssetSource('sounds/message_sound.mp3'));
                                }
                                userMessage = null;
                                messageController.clear();
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

  String getTime(var hour, var minute, var second, var millisecond, var day,
      var month, var year) {
    String getHour,
        getMinute,
        getSecond,
        getMilliSecond,
        getDay,
        getMonth,
        getYear;

    hour < 10 ? getHour = '0$hour' : getHour = '$hour';

    minute < 10 ? getMinute = '0$minute' : getMinute = '$minute';

    second < 10 ? getSecond = '0$second' : getSecond = '$second';

    millisecond < 10
        ? getMilliSecond = '0$millisecond'
        : getMilliSecond = '$millisecond';

    day < 10 ? getDay = '0$day' : getDay = '$day';

    month < 10 ? getMonth = '0$month' : getMonth = '$month';

    getYear = '$year';

    return '$getHour:$getMinute:$getSecond:$getMilliSecond:$getDay:$getMonth:$getYear';
  }

  void editDialogBox(
      BuildContext context, String text, int index, String itemId) {
    String messageBuffer = '';
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Edit Message',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 20,
              ),
            ),
            content: TextFormField(
              onChanged: (data) {
                messageBuffer = data;
              },
              initialValue: chat[index].text,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.white),
                  gapPadding: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.white),
                  gapPadding: 20,
                ),
                contentPadding: EdgeInsets.all(20),
                suffixIcon: Icon(Icons.edit_rounded),
                suffixIconColor: Colors.white,
              ),
            ),
            backgroundColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            actionsPadding:
                const EdgeInsets.only(top: 10, right: 10, bottom: 20),
            actions: [
              GestureDetector(
                onTap: () async {
                  messageBuffer == ''
                      ? await updateMessage(messages, itemId, chat[index].text)
                      : await updateMessage(
                          messages, itemId, messageBuffer.trim());
                  Navigator.pop(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Edit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
