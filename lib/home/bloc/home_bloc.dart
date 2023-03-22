import 'dart:async';
import 'package:chat_bloc_app/model/userModel.dart';
import 'package:chat_bloc_app/util/preference_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util/firebase_util.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      emit(HomeLoadedState());
    });
    on<LogoutEvent>(_logout);
    on<SetOnlineStatusEvent>(_setStatus);
    on<LastSeenEvent>(_lastSeen);
  }

  FutureOr<void> _logout(LogoutEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoadedState(logoutLoader: true));
      await FirebaseAuth.instance.signOut();
      PreferenceHelper.instance().clearPreference();
      emit(HomeLoadedState(logoutLoader: false, logout: true));
    } on FirebaseAuthException catch (e) {
      emit(HomeError(e.message ?? ""));
      print(e);
    } finally {
      emit(HomeLoadedState(logoutLoader: false));
    }
  }

  FutureOr<void> _setStatus(SetOnlineStatusEvent event, Emitter<HomeState> emit) async {
    final result = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: MyFirebaseUtil.instance.getUid())
        .get();
    var docId = result.docs.first.id;
    if (event.isOnline) {
      FirebaseFirestore.instance.collection('user').doc(docId).update({'is_online': 'true'});
    } else {
      FirebaseFirestore.instance.collection('user').doc(docId).update({'is_online': 'false'});
    }
    print("-----print-----  hiii$state  ${event.isOnline}");
  }

  FutureOr<void> _lastSeen(LastSeenEvent event, Emitter<HomeState> emit) async {
    final result = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: MyFirebaseUtil.instance.getUid())
        .get();
    var docId = result.docs.first.id;

    FirebaseFirestore.instance
        .collection('user')
        .doc(docId)
        .update({'last_seen': DateTime.now().millisecondsSinceEpoch.toString()});
  }
}
