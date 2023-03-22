import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../model/address.dart';
import '../../../model/products.dart';
import '../../../util/const.dart';
import '../../../util/firebase_util.dart';

part 'buy_now_event.dart';

part 'buy_now_state.dart';

class BuyNowBloc extends Bloc<BuyNowEvent, BuyNowState> {
  BuyNowBloc() : super(BuyNowInitial()) {
    on<BuyNowEvent>((event, emit) {});
    on<LoadAddressEvent>(_loadAddress);
    on<ChangeIndexEvent>(_changeIndex);
    on<BuyEvent>(_buyProduct);
  }

  Future<FutureOr<void>> _loadAddress(LoadAddressEvent event, Emitter<BuyNowState> emit) async {
    emit(BuyNowLoaded(selectedAddressIndex: 0));
    BuyNowLoaded lastState = state as BuyNowLoaded;

    emit(lastState.copyWith(loader: true));

    Stream<QuerySnapshot<Object?>> res = FirebaseFirestore.instance
        .collection(addressTable)
        .where(
          FireKeys.userId,
          isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "",
        )
        .snapshots();
    try {
      await res.forEach((snapshot) {
        lastState.addressList = [];
        if (snapshot.docs.isEmpty) {
          emit(lastState.copyWith(addressList: []));
        } else {
          for (var element in snapshot.docs) {
            Map<String, dynamic> data = element.data() as Map<String, dynamic>;
            lastState.addressList?.add(Address.fromMap(data, element.id));
            emit(
              lastState.copyWith(
                addressList: lastState.addressList,
              ),
            );
          }
        }
      });
    } catch (e) {
      emit(BuyNowErrorState(e.toString()));
      print(e);
    }
  }

  FutureOr<void> _changeIndex(ChangeIndexEvent event, Emitter<BuyNowState> emit) {
    BuyNowLoaded lastState = state as BuyNowLoaded;
    emit(lastState.copyWith(selectedAddressIndex: event.index));
  }

  FutureOr<void> _buyProduct(BuyEvent event, Emitter<BuyNowState> emit) async {
    BuyNowLoaded lastState = state as BuyNowLoaded;
    emit(lastState.copyWith(buyLoader: true));
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection(orderTable);

      var map = {
        FireKeys.userId: FirebaseAuth.instance.currentUser?.uid ?? "",
        FireKeys.productDocId: event.product.id,
        FireKeys.title: event.product.title,
        FireKeys.qty: event.qty.toString(),
        FireKeys.color: event.color,
        FireKeys.size: event.size,
        FireKeys.photo: event.product.photoList?.first,
        FireKeys.address: event.address.toMap(),
        FireKeys.orderStatus: OrderStatus.placed.name.toString(),
        "created_time": DateTime.now().toString(),
      };
      await collection.add(map);
      emit(lastState.copyWith(buyLoader: false));
      emit(BuySuccessState());
    } catch (e) {
      print(e);
      emit(lastState.copyWith(buyLoader: false));
      emit(BuyNowErrorState(e.toString()));
    }
  }
}
