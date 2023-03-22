import 'dart:async';

import 'package:chat_bloc_app/signup/bloc/signup_event.dart';
import 'package:chat_bloc_app/signup/bloc/signup_state.dart';
import 'package:chat_bloc_app/util/preference_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupBloc extends Bloc<SignUpEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<BtnTapEvent>(_signup);
  }

  FutureOr<void> _signup(BtnTapEvent event, Emitter<SignupState> emit) async {
    if (event.name.isEmpty) {
      emit(SignupErrorState(msg: 'Please enter name'));
    } else if (event.email.isEmpty) {
      emit(SignupErrorState(msg: 'Please enter email'));
    } else if (event.pwd.isEmpty) {
      emit(SignupErrorState(msg: 'Please enter password'));
    } else if (event.pwd.length < 6) {
      emit(SignupErrorState(msg: 'Password should be at least 6 characters'));
    } else {
      try {
        emit(SignupLoadedState(loader: true));
       UserCredential user= await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email,
          password: event.pwd,
        );

        await FirebaseFirestore.instance.collection('user').add({
          'name': event.name,
          'email': event.email,
          'uid':user.user?.uid.toString(),
          'createdAt':DateTime.now().toString()

        });
        await PreferenceHelper.instance().setPreference(PreferenceHelper.isLogin, true, PrefTypes.bool);
        emit(SignupSuccess());
      } on Exception catch (e) {
        emit(SignupErrorState(msg: e.toString()));
        print(e);
      } finally {
        emit(SignupLoadedState(loader: false));
      }
    }
  }
}
