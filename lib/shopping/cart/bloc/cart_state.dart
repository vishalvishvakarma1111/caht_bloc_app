part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoadedState extends CartState {
  final bool? loader;
  List<Product>? cartList;

  CartLoadedState({
    this.loader,
    this.cartList,
  });

  CartLoadedState copyWith({
    bool? loader,
    List<Product>? cartList,
  }) {
    return CartLoadedState(
      loader: loader ?? this.loader,
      cartList: cartList ?? this.cartList,
    );
  }
}

class CartError extends CartState {
  final String msg;

  CartError(this.msg);
}
