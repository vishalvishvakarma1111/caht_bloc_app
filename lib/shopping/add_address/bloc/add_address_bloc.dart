import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_bloc_app/util/firebase_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../util/const.dart';

part 'add_address_event.dart';

part 'add_address_state.dart';

class AddAddressBloc extends Bloc<AddAddressEvent, AddAddressState> {
  AddAddressBloc() : super(AddAddressInitial()) {
    on<AddAddressEvent>((event, emit) {});
    on<EventInitial>((event, emit) {
      emit(AddressLoadedState());
    });
    on<SubmitEvent>(_submit);
  }

  FutureOr<void> _submit(SubmitEvent event, Emitter<AddAddressState> emit) async {
    if (event.name.isEmpty) {
      emit(AddressError("Please enter name"));
    } else if (event.phone.isEmpty) {
      emit(AddressError("Please enter phone"));
    } else if (event.address.isEmpty) {
      emit(AddressError("Please enter address"));
    } else if (event.city.isEmpty) {
      emit(AddressError("Please city name"));
    } else if (event.state.isEmpty) {
      emit(AddressError("Please enter state"));
    } else if (event.zip.isEmpty) {
      emit(AddressError("Please enter zip"));
    } else {
      try {
        emit(AddressLoadedState(loader: true));
        CollectionReference collection = FirebaseFirestore.instance.collection(addressTable);

        var map = {
          FireKeys.userId: FirebaseAuth.instance.currentUser?.uid ?? "",
          FireKeys.userName: event.name,
          FireKeys.phone: event.phone,
          FireKeys.address: event.address,
          FireKeys.city: event.city,
          FireKeys.state: event.state,
          FireKeys.zipCode: event.zip,
          "created_time": DateTime.now().toString(),
        };

        await collection.add(map);
        emit(AddressSuccess());
      } catch (e) {
        print("-----print-----   ${e.toString()}");
        emit(AddressError(e.toString()));
      }
    }
    emit(AddressLoadedState(loader: false));
  }
}
