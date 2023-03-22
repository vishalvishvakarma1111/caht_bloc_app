part of 'add_address_bloc.dart';

@immutable
abstract class AddAddressState {}

class AddAddressInitial extends AddAddressState {}

class AddressLoadedState extends AddAddressState {
  final bool? loader;

  AddressLoadedState({this.loader});
}

class AddressError extends AddAddressState {
  final String msg;

  AddressError(this.msg);
}

class AddressSuccess extends AddAddressState {
  AddressSuccess();
}
