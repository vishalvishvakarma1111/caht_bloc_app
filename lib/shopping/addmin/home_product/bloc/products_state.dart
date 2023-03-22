part of 'products_bloc.dart';

@immutable
abstract class ProductsListState {}

class ProductsListInitial extends ProductsListState {}

class LoaderState extends ProductsListState {}

class FailureState extends ProductsListState {
  final String errorMsf;

  FailureState({required this.errorMsf});
}

class ProductsListLoaded extends ProductsListState {
  List<Product> productList;

  ProductsListLoaded({required this.productList});
}
