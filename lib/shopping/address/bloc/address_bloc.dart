import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_bloc_app/shopping/add_address/bloc/add_address_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../model/address.dart';
import '../../../util/const.dart';
import '../../../util/firebase_util.dart';

part 'address_event.dart';

part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressInitial()) {
    on<AddressEvent>((event, emit) {
      emit(AddressLoadedState());
    });
    on<LoadAddressEvent>(_loadAddress);
  }

  FutureOr<void> _loadAddress(LoadAddressEvent event, Emitter<AddressState> emit) async {
    AddressLoadedState lastState = state as AddressLoadedState;

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
      emit(AddressErrorState(e.toString()));
      print(e);
    }
  }
}
