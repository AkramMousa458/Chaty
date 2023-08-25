import '../constants.dart';

class Message {
  final String text;
  final String time;
  final String id;

  Message(this.text, this.time, this.id);

  factory Message.fromJson(jsonData) {
    return Message(jsonData[kMessage], jsonData[kTime], jsonData[kId]);
  }
}
