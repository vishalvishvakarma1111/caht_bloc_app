part of 'products_bloc.dart';

@immutable
abstract class ProductsListEvent {}

class ProductsListLoadEvent extends ProductsListEvent {
  List<Product> list;

  ProductsListLoadEvent(this.list);
}

class ProductsListDeleteEvent extends ProductsListEvent {
  final Product item;

  final List<Product> list;

  ProductsListDeleteEvent({required this.item, required this.list});
}
