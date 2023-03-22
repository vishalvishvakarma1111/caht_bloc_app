part of 'add_address_bloc.dart';

@immutable
abstract class AddAddressEvent {}

class SubmitEvent extends AddAddressEvent {
  String name, phone, address, city, state, zip;

  SubmitEvent(this.name, this.phone, this.address, this.city, this.state, this.zip);
}

class EventInitial  extends AddAddressEvent{}
