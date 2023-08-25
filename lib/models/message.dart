import '../constants.dart';

class Message {
  final String text;
  final String time;
  final String id;
  final String friendId;

  Message(this.text, this.time, this.id, this.friendId);

  factory Message.fromJson(jsonData) {
    return Message(jsonData[kMessage], jsonData[kTime], jsonData[kId],
        jsonData[kFriendId]);
  }
}
