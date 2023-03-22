import 'dart:async';
import 'dart:io';

import 'package:chat_bloc_app/user_profile/bloc/profile_event.dart';
import 'package:chat_bloc_app/user_profile/bloc/profile_state.dart';
import 'package:chat_bloc_app/util/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/profile.dart';
import '../../util/firebase_util.dart';
import '../../util/preference_helper.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileInitial()) {
    on<ProfileEvent>((event, emit) {});
    on<LogoutTapEvent>(_logout);
    on<LoadProfile>(_loadProfile);
    on<UpdateProfileEvent>(_updateProfile);
    on<SelectPhotoEvent>(_selectPhoto);
  }

  FutureOr<void> _logout(LogoutTapEvent event, Emitter<ProfileState> emit) async {
    await FirebaseAuth.instance.signOut();
    PreferenceHelper.instance().clearPreference();
    emit(const ProfileLogout());
  }

  Future<FutureOr<void>> _loadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoader());
    try {
      print("-----print---FirebaseAuth.instance.currentUser?.uid ?? "
          "--   ${FirebaseAuth.instance.currentUser?.uid ?? ""}");
      QuerySnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
          .collection(userTable)
          .where(FireKeys.uid, isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "")
          .get();

      Map<String, dynamic> map = doc.docs.first.data();
      Profile profile = Profile.fromJson(map);
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      print(e);
      emit(ProfileError(msg: e.toString()));
    }
  }

  Future<FutureOr<void>> _updateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    ProfileLoaded lastState = state as ProfileLoaded;
    emit(const ProfileUpdateLoader());
    if (lastState.profile.file != null) {
      final storage = FirebaseStorage.instance.ref().child("/images/profile_pic");
      TaskSnapshot taskSnapshot = await storage.putFile(File(lastState.profile.file?.path ?? ""));

      String url = await taskSnapshot.ref.getDownloadURL();
      lastState.profile.url = url;
    }

    Map<String, dynamic> map = {};
    map[FireKeys.userName] = event.profile.name ?? "";
    map[FireKeys.description] = event.profile.desc ?? "";
    map[FireKeys.profilePic] = lastState.profile.url ?? "";
    map[FireKeys.uid] = FirebaseAuth.instance.currentUser?.uid ?? "";

    var data = await FirebaseFirestore.instance
        .collection(userTable)
        .where(FireKeys.uid, isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "")
        .get();

    print("-----print-----   ${data.docs.first.id}");

    await FirebaseFirestore.instance.collection(userTable).doc(data.docs.first.id).update(map);

    var profile = Profile(
      desc: event.profile.desc,
      name: event.profile.name,
      url: lastState.profile.url,
    );

    emit(const ProfileSuccess());
    emit(ProfileLoaded(profile: profile));
  }

  FutureOr<void> _selectPhoto(SelectPhotoEvent event, Emitter<ProfileState> emit) {
    ProfileLoaded lastState = state as ProfileLoaded;
    emit(ProfileLoaded(
        profile: Profile(
      name: lastState.profile.name,
      desc: lastState.profile.desc,
      file: event.profile.file,
    )));
  }
}
