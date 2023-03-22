part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatInitialEvent extends ChatEvent {
  final UserModel peer;

  ChatInitialEvent({required this.peer});
}

class SendMessageEvent extends ChatEvent {
  final String msg;

  SendMessageEvent({
    required this.msg,
  });
}

class UploadImageEvent extends ChatEvent {}
