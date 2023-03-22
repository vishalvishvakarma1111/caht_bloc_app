import 'dart:async';
import 'dart:core';
import 'dart:core';

import 'package:chat_bloc_app/model/common.dart';
import 'package:chat_bloc_app/util/firebase_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/products.dart';

part 'products_event.dart';

part 'products_state.dart';

class ProductsListBloc extends Bloc<ProductsListEvent, ProductsListState> {
  CollectionReference productsCollection = FirebaseFirestore.instance.collection(productTable);

  ProductsListBloc() : super(ProductsListInitial()) {
    on<ProductsListEvent>((event, emit) {});
    on<ProductsListLoadEvent>(_loadlist);
    on<ProductsListDeleteEvent>(_deleteProduct);
  }

  Future<FutureOr<void>> _loadlist(ProductsListLoadEvent event, Emitter<ProductsListState> emit) async {
    emit(LoaderState());
   try {
      Stream<QuerySnapshot<Object?>> res = productsCollection.snapshots();

      await res.forEach((snapshot) {
        event.list = [];
        if (snapshot.docs.isEmpty) {
          emit(ProductsListLoaded(productList: event.list));
        } else {
          for (var element in snapshot.docs) {
            Map<String, dynamic> data = element.data() as Map<String, dynamic>;
            event.list.add(Product.fromMap(data, element.id));
            emit(ProductsListLoaded(productList: event.list));
          }
        }
      });
    } catch (e) {
      emit(FailureState(errorMsf: e.toString()));
      print(e);
    }
  }

  FutureOr<void> _deleteProduct(ProductsListDeleteEvent event, Emitter<ProductsListState> emit) {
    productsCollection.doc(event.item.id.toString()).delete();
  }
}
