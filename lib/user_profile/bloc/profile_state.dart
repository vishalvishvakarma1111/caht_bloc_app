import 'package:chat_bloc_app/model/profile.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ProfileState {
  final Profile? profile;

  const ProfileState(this.profile);
}

class ProfileInitial extends ProfileState {
  const ProfileInitial() : super(null);
}

class ProfileLoader extends ProfileState {
  const ProfileLoader() : super(null);
}

class ProfileUpdateLoader extends ProfileState {
  const ProfileUpdateLoader() : super(null);
}

class ProfileLoaded extends ProfileState {
  final Profile profile;
  final bool? logoutLoader;

  ProfileLoaded({required this.profile, this.logoutLoader}) : super(null);

  ProfileLoaded copyData(
    Profile? profiles,
    bool? logoutLoader,
  ) {
    return ProfileLoaded(
      profile: profiles ?? this.profile,
      logoutLoader: logoutLoader ?? this.logoutLoader,
    );
  }
}

class ProfileLogoutLoader extends ProfileState {
  const ProfileLogoutLoader() : super(null);
}

class ProfileError extends ProfileState {
  final String msg;

  const ProfileError({required this.msg}) : super(null);
}

class ProfileSuccess extends ProfileState {
  const ProfileSuccess() : super(null);
}

class ProfileLogout extends ProfileState {
  const ProfileLogout():super(null);
}
