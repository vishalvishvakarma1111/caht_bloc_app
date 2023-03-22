
import 'package:flutter/material.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoadedState extends SignupState {
  final bool loader;

  SignupLoadedState({this.loader = false});

  SignupLoadedState copyWith(bool? loader) {
    return SignupLoadedState(
      loader: loader ?? this.loader,
    );
  }
}

class SignupSuccess extends SignupState {}

class SignupErrorState extends SignupState {
  final String msg;

  SignupErrorState({required this.msg});
}
