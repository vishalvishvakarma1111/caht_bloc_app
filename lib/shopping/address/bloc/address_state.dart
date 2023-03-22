part of 'address_bloc.dart';

@immutable
abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoadedState extends AddressState {
  final bool? loader;

  List<Address>? addressList;

  AddressLoadedState({
    this.loader,
    this.addressList,
  });

  AddressLoadedState copyWith({
    bool? loader,
    List<Address>? addressList,
  }) {
    return AddressLoadedState(
      loader: loader ?? this.loader,
      addressList: addressList ?? this.addressList,
    );
  }
}

class AddressErrorState extends AddressState {
  final String msg;

  AddressErrorState(this.msg);
}
