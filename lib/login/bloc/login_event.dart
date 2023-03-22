part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginBtnTapEvent extends LoginEvent {
  final String email;
  final String pwd;

  LoginBtnTapEvent({required this.email, required this.pwd});
}
