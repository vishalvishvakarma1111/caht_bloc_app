import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

import '../../../util/firebase_util.dart';

part 'add_cate_event.dart';

part 'add_cate_state.dart';

class AddCateBloc extends Bloc<AddCateEvent, AddCateState> {
  CollectionReference categoryCollection = FirebaseFirestore.instance.collection(categoryTable);

  AddCateBloc() : super(AddCateInitial()) {
    on<AddCateEvent>((event, emit) {});
    on<AddCate>(_onSubmit);
    on<UpdateNotesTap>(_onUpdateNotes);
  }

  Future<FutureOr<void>> _onSubmit(AddCate event, Emitter<AddCateState> emit) async {
    final result = await FirebaseFirestore.instance.collection(categoryTable).where('title', isEqualTo: event.title).get();
    String title = '';
    if (result.docs.isNotEmpty) {
      title = result.docs.first.data()['title'];
    }

    if (event.title.isEmpty) {
      emit(ErrorState(errorMsg: "Please enter title"));
    } else if (title == event.title.trim()) {
      emit(ErrorState(errorMsg: "Already added before"));
    } else {
      emit(LoadingState());
      try {
        DocumentReference<Object?> res = await categoryCollection.add({
          "title": event.title,
          "created_time": DateTime.now().toString(),
        });
        emit(AddCateSuccess());
      } catch (e) {
        emit(ErrorState(errorMsg: e.toString()));

        log("message---error ", error: e.toString());
      }
    }
  }

  FutureOr<void> _onUpdateNotes(UpdateNotesTap event, Emitter<AddCateState> emit) async {
    final result = await FirebaseFirestore.instance.collection(categoryTable).where('title', isEqualTo: event.title).get();
    String title = '';
    if (result.docs.isNotEmpty) {
      title = result.docs.first.data()['title'];
    }

    if (event.title.isEmpty) {
      emit(ErrorState(errorMsg: "Please enter title"));
    } else if (title == event.title.trim()) {
      emit(ErrorState(errorMsg: "Already added before"));
    } else {
      emit(LoadingState());
      try {
        final result = await FirebaseFirestore.instance.collection(categoryTable).get();
        var title = result.docs.first.data()['title'];

        await categoryCollection.doc(event.id).set({
          "title": event.title,
          "update_time": DateTime.now().toString(),
        });
        emit(AddCateSuccess());
      } catch (e) {
        emit(ErrorState(errorMsg: e.toString()));

        log("message---error ", error: e.toString());
      }
    }
  }
}
