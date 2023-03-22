part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class LogoutEvent extends HomeEvent {}
class LastSeenEvent extends HomeEvent {}

class SetOnlineStatusEvent extends HomeEvent {
  final bool isOnline;

  SetOnlineStatusEvent({
    required this.isOnline,
  });
}
