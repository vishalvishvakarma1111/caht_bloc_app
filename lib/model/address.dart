import 'package:chat_bloc_app/util/const.dart';

class Address {
  String? address, name, phone, city, state, zipCode, id;

  Address({
    this.id,
    this.address,
    this.name,
    this.phone,
    this.city,
    this.state,
    this.zipCode,
  });

  factory Address.fromMap(Map<String, dynamic> map, String id) {
    return Address(
      id: id,
      address: map[FireKeys.address],
      name: map[FireKeys.userName],
      phone: map[FireKeys.phone],
      city: map[FireKeys.city],
      state: map[FireKeys.state],
      zipCode: map[FireKeys.zipCode],
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'address':   address,
      'name':  name,
      'phone': phone,
      'city':   city,
      'state':   state,
      'zipCode':   zipCode,
      'id':   id,
    };
  }

}
