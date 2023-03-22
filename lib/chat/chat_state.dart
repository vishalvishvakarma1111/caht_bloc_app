part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoadedState extends ChatState {
  final bool? loader;

  ChatLoadedState({this.loader});
}
