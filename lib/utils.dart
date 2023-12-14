// ignore_for_file: depend_on_referenced_packages, avoid_print, avoid_single_cascade_in_expression_statements

import 'dart:js_util';

import 'package:akram/constants.dart';
import 'package:akram/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:akram/models/user.dart';

Future<String> getDocumentId({required CollectionReference messages, required Message message}) async {
    String documentId = '';
    try {
      QuerySnapshot querySnapshot = await messages.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          if (equal(message , document)) documentId = document.id;
        }
      } else {
        print('No documents found');
      }
    } catch (e) {
      print('Error getting documents: $e');
    }
    return documentId;
  }

deleteMessage(CollectionReference messages, String id) async {
  messages.doc(id).delete()
    ..then((_) => print('Deleted'))
        .catchError((error) => print('Delete failed: $error'));
}

updateMessage(CollectionReference messages, String id, String text) {
  messages.doc(id).update({kMessage: text})
    ..then((_) => print('${messages.doc(id).toString()}Edited'))
        .catchError((error) => print('Edit failed: $error'));
}

String findUserName(List<User> list, String email) {
  for (int i = 0; i < list.length; i++) {
    if (list[i].email == email) {
      return list[i].name;
    }
  }
  return 'User Name';
}

String findUserPhoto(List<User> list, String email) {
  for (int i = 0; i < list.length; i++) {
    if (list[i].email == email) {
      return list[i].photo;
    }
  }
  return 'User Photo';
}

String findUserStatues(List<User> list, String email) {
  for (int i = 0; i < list.length; i++) {
    if (list[i].email == email) {
      return list[i].statues;
    }
  }
  return 'User Statues';
}
