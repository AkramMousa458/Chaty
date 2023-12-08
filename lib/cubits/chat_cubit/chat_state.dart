part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitialState extends ChatState {}

final class ChatSucsessState extends ChatState {
  // ChatSucsessState({required this.messagesList, required this.chat});
  // final List<Message> messagesList;
  // final List<Message> chat;
}

final class ChatFailureState extends ChatState {
  ChatFailureState({required this.errMessage});
  final String errMessage;
}

final class ChatDeleteMessageFailureState extends ChatState {
  ChatDeleteMessageFailureState({required this.errMessage});
  final String errMessage;
}

final class ChatEditMessageSucssesState extends ChatState {}
