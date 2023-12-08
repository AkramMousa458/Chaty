// ignore_for_file: depend_on_referenced_packages
import 'package:akram/utils.dart';
import 'package:bloc/bloc.dart';

import 'package:akram/constants.dart';
import 'package:akram/models/message.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);

  List<Message> messagesList = [];
  // List<Message> chat = [];

  ChatCubit() : super(ChatInitialState());

  void getMessages(
      {required BuildContext context,
      required String userEmail,
      required String friendEmail}) {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      try {
        for (var doc in event.docs) {
          messagesList.add(
            Message.fromJson(doc),
          );
        }
        emit(ChatSucsessState());
        
      } on Exception {
        emit(ChatFailureState(
            errMessage: 'Error while deleting message, try again'));
      }

      // chat = getChat(messagesList, userEmail, friendEmail, context);
    });
  }

  List<Message> getChat(List<Message> list, String sender, String receiver,
      BuildContext context) {
    List<Message> userChat = [];
    for (int i = 0; i < list.length; i++) {
      if ((list[i].id == sender && list[i].friendId == receiver) ||
          list[i].friendId == sender && list[i].id == receiver) {
        userChat.add(list[i]);
      }
    }
    return userChat;
  }

  void sendMessage(
      {required String userMessage,
      required String userEmail,
      required String friendEmail,
      required BuildContext context}) {
    if (userMessage != '') {
      messages.add({
        kMessage: userMessage.trim(),
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
        kId: userEmail,
        kFriendId: friendEmail
      });
    }
  }

  void delMessage({required String itemId}) {
    try {
      deleteMessage(messages, itemId);
    } on Exception {
      emit(ChatDeleteMessageFailureState(
          errMessage: 'Error while deleting message, try again'));
    }
  }

  void editMessage(
      {required BuildContext context,
      required String text,
      required int index,
      required String itemId,
      required List<Message> chat}) {
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
                  emit(ChatEditMessageSucssesState());
                  // Navigator.pop(context);
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
}
