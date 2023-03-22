import 'dart:async';
import 'dart:core';
import 'dart:core';

import 'package:chat_bloc_app/model/common.dart';
import 'package:chat_bloc_app/util/firebase_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'catelist_event.dart';

part 'catelist_state.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  CollectionReference categoryCollection = FirebaseFirestore.instance.collection(categoryTable);

  CategoryListBloc() : super(CategoryListInitial()) {
    on<CategoryListEvent>((event, emit) {});
    on<CategoryListLoadEvent>(_loadlist);
    on<CategoryListDeleteEvent>(_deleteNotes);
  }

  Future<FutureOr<void>> _loadlist(CategoryListLoadEvent event, Emitter<CategoryListState> emit) async {
    emit(LoaderState());
    try {
      Stream<QuerySnapshot<Object?>> res = categoryCollection.snapshots();

      await res.forEach((snapshot) {
        event.list = [];
        if (snapshot.docs.isEmpty) {
          emit(CategoryListLoaded(categoryList: event.list));
        } else {
          for (var element in snapshot.docs) {
            Map<String, dynamic> data = element.data() as Map<String, dynamic>;
            event.list.add(CommonModel.fromMap(data, element.id));
            emit(CategoryListLoaded(categoryList: event.list));
          }
        }
      });
    } catch (e) {
      emit(FailureState(errorMsf: e.toString()));
      print(e);
    }
  }

  FutureOr<void> _deleteNotes(CategoryListDeleteEvent event, Emitter<CategoryListState> emit) {
    categoryCollection.doc(event.item.id).delete();
  }
}
