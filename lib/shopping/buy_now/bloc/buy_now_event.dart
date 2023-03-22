part of 'buy_now_bloc.dart';

@immutable
abstract class BuyNowEvent {}

class LoadAddressEvent extends BuyNowEvent {}

class ChangeIndexEvent extends BuyNowEvent {
  final int index;

  ChangeIndexEvent(this.index);
}

class BuyEvent extends BuyNowEvent {
  final Product product;
  final String size;
  final String color;
  final int qty;
  final Address address;

  BuyEvent({
    required this.product,
    required this.size,
    required this.color,
    required this.qty,
    required this.address,
  });
}
