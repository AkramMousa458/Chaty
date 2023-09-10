// ignore_for_file: depend_on_referenced_packages

import 'package:akram/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:akram/models/user.dart';

deleteMessage(CollectionReference messages, String id) {
  messages.doc(id).delete()
    ..then((_) => print('Deleted'))
        .catchError((error) => print('Delete failed: $error'));
}

updateMessage(CollectionReference messages, String id, String text) {
  messages.doc(id).update({kMessage: text})
    ..then((_) => print('Edited'))
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
