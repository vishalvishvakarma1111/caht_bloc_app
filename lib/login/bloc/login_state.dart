part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadedState extends LoginState {
  final bool loader;

  LoginLoadedState({this.loader = false});

  LoginLoadedState copyWith(bool? loader) {
    return LoginLoadedState(
      loader: loader ?? this.loader,
    );
  }
}

class LoginSuccess extends LoginState {}

class LoginErrorState extends LoginState {
  final String msg;

  LoginErrorState({required this.msg});
}
