import 'dart:async';

import 'package:chat_bloc_app/util/firebase_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util/preference_helper.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {});
    on<LoginBtnTapEvent>(_login);
  }

  Future<FutureOr<void>> _login(LoginBtnTapEvent event, Emitter<LoginState> emit) async {
    try {
      if (event.email.isEmpty) {
        emit(LoginErrorState(msg: "please enter email"));
      } else if (event.pwd.isEmpty) {
        emit(LoginErrorState(msg: "please enter password"));
      } else {
        emit(LoginLoadedState(loader: true));
        UserCredential user =
            await FirebaseAuth.instance.signInWithEmailAndPassword(email: event.email.trim(), password: event.pwd);
        await PreferenceHelper.instance().setPreference(PreferenceHelper.isLogin, true, PrefTypes.bool);

        final result =
            await FirebaseFirestore.instance.collection('user').where('uid', isEqualTo: user.user?.uid ?? "").get();
        var docId = result.docs.first.id;
        String token = await MyFirebaseUtil.instance.getToken() ?? '';

        FirebaseFirestore.instance.collection('user').doc(docId).update({'token': token});

        emit(LoginLoadedState(loader: false));
        emit(LoginSuccess());
      }
    } on FirebaseException catch (e) {
      emit(LoginErrorState(msg: e.message ?? ""));
      print(e);
    }
  }
}
