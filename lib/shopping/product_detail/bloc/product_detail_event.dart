part of 'product_detail_bloc.dart';

@immutable
abstract class ProductDetailEvent {}

class SelectSizeEvent extends ProductDetailEvent {
  final int index;

  SelectSizeEvent(this.index);
}

class SelectColorEvent extends ProductDetailEvent {
  final int index;

  SelectColorEvent(this.index);
}

class AddToCartEvent extends ProductDetailEvent {
  final Product product;

  AddToCartEvent(this.product);
}

class BuyEvent extends ProductDetailEvent {
  final Product product;

  BuyEvent(this.product);
}

class AddRemoveEvent extends ProductDetailEvent {
  final bool isAdd;
  final Product product;

  AddRemoveEvent(this.isAdd, this.product);
}

class InitialEvent extends ProductDetailEvent {
  final Product product;

  InitialEvent(this.product);
}
