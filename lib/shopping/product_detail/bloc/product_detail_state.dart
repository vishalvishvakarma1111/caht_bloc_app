part of 'product_detail_bloc.dart';

@immutable
abstract class ProductDetailState {}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailErrorState extends ProductDetailState {
  final String msg;

  ProductDetailErrorState(this.msg);
}

class ProductDetailLoaded extends ProductDetailState {
  final int? colorIndex;
  final int? sizeIndex;
  late final int? cartItemCount;
  final bool? loader;
  final bool? isAddedToCart;

  ProductDetailLoaded({
    this.colorIndex,
    this.sizeIndex,
    this.cartItemCount,
    this.loader,
    this.isAddedToCart,
  });

  ProductDetailLoaded copyWith({
    int? colorIndex,
    int? sizeIndex,
    int? cartItemCount,
    bool? loader,
    bool? isAddedToCart,
  }) {
    return ProductDetailLoaded(
      colorIndex: colorIndex ?? this.colorIndex,
      sizeIndex: sizeIndex ?? this.sizeIndex,
      cartItemCount: cartItemCount ?? this.cartItemCount,
      loader: loader ?? this.loader,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
    );
  }
}
