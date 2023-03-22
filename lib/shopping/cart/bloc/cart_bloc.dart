import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_bloc_app/util/const.dart';
import 'package:chat_bloc_app/util/firebase_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../model/products.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<CartEvent>((event, emit) {});
    on<LoadCartEvent>(_loadCart);
  }

  FutureOr<void> _loadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadedState(loader: true));
    try {
      CartLoadedState lastState = state as CartLoadedState;
      CollectionReference categoryCollection = FirebaseFirestore.instance.collection(cartTable);
      Stream<QuerySnapshot<Object?>> res = categoryCollection
          .where(
            FireKeys.userId,
            isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '',
          )
          .snapshots();

      await res.forEach((snapshot) {
        lastState.cartList = [];
        if (snapshot.docs.isEmpty) {
          emit(CartLoadedState(cartList: const []));
        } else {
          for (var element in snapshot.docs) {
            Map<String, dynamic> data = element.data() as Map<String, dynamic>;
            lastState.cartList?.add(Product.fromMap(data, element.id));
            emit(CartLoadedState(cartList: lastState.cartList));
          }
        }
      });
    } catch (e) {
      emit(CartError(e.toString()));
      emit(CartLoadedState(cartList: const []));

      print(e);
    }
  }
}
