import 'package:chat_bloc_app/model/common.dart';
import 'package:flutter/material.dart';

import '../../../model/products.dart';

@immutable
abstract class HomeShoppingState {}

class HomeShoppingInitial extends HomeShoppingState {}

class HomeLoadedState extends HomeShoppingState {
  int? selectedTabIndex;
  bool? loader;

  List<CommonModel>? tabList = [];
  List<Product>? productList = [];

  HomeLoadedState({
    this.selectedTabIndex,
    this.tabList,
    this.loader,
    this.productList,
  });

  HomeLoadedState copyWith({
    int? selectedTabIndex,
    bool? loader,
    List<CommonModel>? tabList,
    List<Product>? productList,
  }) {
    return HomeLoadedState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      tabList: tabList ?? this.tabList,
      loader: loader ?? this.loader,
      productList: productList ?? this.productList,
    );
  }
}

class HomeErrorState extends HomeShoppingState {
  final String msg;

  HomeErrorState(this.msg);
}
