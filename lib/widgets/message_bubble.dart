import 'package:akram/constants.dart';
import 'package:akram/models/message.dart';
import 'package:flutter/material.dart';

class MessageBubbleSend extends StatelessWidget {
  const MessageBubbleSend({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          margin: const EdgeInsets.only(top: 12, left: 12, right: 12),
          decoration: BoxDecoration(
              color: Colors.green[800],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SelectableText(
                textAlign: TextAlign.left,
                message.text,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                message.time,
                style: const TextStyle(fontSize: 9, color: Colors.grey),
              )
            ],
          )),
    );
  }
}

class MessageBubbleReceive extends StatelessWidget {
  const MessageBubbleReceive({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          margin: const EdgeInsets.only(top: 12, left: 12, right: 12),
          decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SelectableText(
                textAlign: TextAlign.left,
                message.text,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                message.time,
                style: const TextStyle(fontSize: 9, color: Colors.grey),
              )
            ],
          )),
    );
  }
}
