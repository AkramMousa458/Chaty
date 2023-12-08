// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:akram/constants.dart';
import 'package:akram/cubits/chat_cubit/chat_cubit.dart';
import 'package:akram/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/screen_args.dart';
import '../widgets/message_bubble.dart';

import 'package:audioplayers/audioplayers.dart';

class ChatScreen extends StatelessWidget {
  static String id = 'ChatScreen';

  TextEditingController messageController = TextEditingController();

  String? userMessage;

  final _controller = ScrollController();

  final soundPlayer = AudioPlayer();
  ScreenArgs? args;

  List<Message> messagesList = [];
  // List<Message> chat = [];

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as ScreenArgs;
    BlocProvider.of<ChatCubit>(context).getMessages(
        context: context,
        userEmail: args!.userEmail,
        friendEmail: args!.friendEmail);

    return BlocConsumer<ChatCubit, ChatState>(listener: (context, state) {
      if (state is ChatSucsessState) {
        messagesList = BlocProvider.of<ChatCubit>(context).messagesList;
      //   chat = [];
      //   chat = BlocProvider.of<ChatCubit>(context).getChat(
      //       BlocProvider.of<ChatCubit>(context).messagesList,
      //       args!.userEmail,
      //       args!.friendEmail,
      //       context);
      //   print('Succsess get chat');
      }
    }, builder: (context, snapshot) {
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
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(args!.friendPhoto),
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(150)),
                    ),
                    const SizedBox(width: 6),
                    Text(args!.friendName)
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
                  // itemCount: chat.length,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    // return BlocProvider.of<ChatCubit>(context).chat[index].id == BlocProvider.of<ChatCubit>(context).args.userEmail &&
                    //         BlocProvider.of<ChatCubit>(context).chat[index].friendId == BlocProvider.of<ChatCubit>(context).args.friendEmail
                    //     ? Slidable(
                    //         key: UniqueKey(),
                    //         endActionPane: ActionPane(
                    //           motion: const ScrollMotion(),
                    //           children: [
                    //             Container(
                    //               width: 30,
                    //               height: 30,
                    //               decoration: BoxDecoration(
                    //                   color: Colors.red,
                    //                   borderRadius:
                    //                       BorderRadius.circular(100)),
                    //               child: GestureDetector(
                    //                 onTap: () {
                    //                   String itemId =
                    //                       snapshot.data!.docs[index].id;
                    //                       BlocProvider.of<ChatCubit>(context).delMessage(itemId: itemId);
                    //                   confirmDialogBox(
                    //                       context: context,
                    //                       onTap: () async {
                    //                         // await deleteMessage(
                    //                         //     messages, itemId);
                    //                         Navigator.pop(context);
                    //                       },
                    //                       title: 'Delete Message',
                    //                       body:
                    //                           'Do you want delete the message',
                    //                       no: 'Cancel',
                    //                       confirm: 'Delete');
                    //                 },
                    //                 child: const Icon(
                    //                   Icons.delete,
                    //                   color: Colors.white,
                    //                   size: 19,
                    //                 ),
                    //               ),
                    //             ),
                    //             const SizedBox(width: 12),
                    //             Container(
                    //               width: 30,
                    //               height: 30,
                    //               decoration: BoxDecoration(
                    //                   color: kPrimaryColor,
                    //                   borderRadius:
                    //                       BorderRadius.circular(100)),
                    //               child: GestureDetector(
                    //                 onTap: () {
                    //                   String itemId =
                    //                       snapshot.data!.docs[index].id;
                    //                   late String text = '';
                    //                   editDialogBox(
                    //                       context, text, index, itemId);

                    //                   setState(() {});
                    //                 },
                    //                 child: const Icon(
                    //                   Icons.edit_rounded,
                    //                   color: Colors.white,
                    //                   size: 19,
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         child:
                    //             MessageBubbleSend(message: BlocProvider.of<ChatCubit>(context).chat[index]))
                    // :
                    // return MessageBubbleReceive(message: chat[index]);
                    return MessageBubbleReceive(message: messagesList[index]);
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
                            BlocProvider.of<ChatCubit>(context).sendMessage(
                                userMessage: data,
                                context: context,
                                userEmail: args!.userEmail,
                                friendEmail: args!.friendEmail);
                            _controller.animateTo(0,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn);
                            soundPlayer
                                .play(AssetSource('sounds/message_sound.mp3'));

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
                          BlocProvider.of<ChatCubit>(context).sendMessage(
                              userMessage: userMessage!,
                              context: context,
                              userEmail: args!.userEmail,
                              friendEmail: args!.friendEmail);

                          _controller.animateTo(0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn);
                          soundPlayer
                              .play(AssetSource('sounds/message_sound.mp3'));

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
    });
  }
}


// else {
//             return Scaffold(
//                 appBar: AppBar(
//                   automaticallyImplyLeading: false,
//                   title: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(kLogo, height: 38),
//                       const SizedBox(width: 6),
//                       const Text('Chaty')
//                     ],
//                   ),
//                   backgroundColor: kPrimaryColor,
//                 ),
//                 body: Column(
//                   children: [
//                     Expanded(
//                       child: Center(
//                         child: Text(
//                           'Waiting to load messages..',
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: kPrimaryColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                         padding: const EdgeInsets.all(15),
//                         child: Row(
//                           children: [
//                             const Expanded(
//                               child: TextField(
//                                 style: TextStyle(fontSize: 18),
//                                 maxLines: 1,
//                                 decoration: InputDecoration(
//                                   hintText: 'Message',
//                                   contentPadding: EdgeInsets.symmetric(
//                                       vertical: 14, horizontal: 20),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(200),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             GestureDetector(
//                               child: Container(
//                                 padding: const EdgeInsets.all(14),
//                                 margin: const EdgeInsets.only(left: 5),
//                                 decoration: BoxDecoration(
//                                     color: kPrimaryColor,
//                                     borderRadius: BorderRadius.circular(100)),
//                                 child: const Icon(
//                                   Icons.send_rounded,
//                                   size: 30,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             )
//                           ],
//                         ))
//                   ],
//                 ));
//           }