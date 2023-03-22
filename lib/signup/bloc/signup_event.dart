import 'package:flutter/material.dart';

@immutable
abstract class SignUpEvent {}

class SignupInitialEvent extends SignUpEvent {}

class BtnTapEvent extends SignUpEvent {
  final String name;
  final String email;
  final String pwd;

  BtnTapEvent({required this.name,required this.email, required this.pwd});
}
