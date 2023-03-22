part of 'home_shopping_bloc.dart';

@immutable
abstract class HomeShoppingEvent {}

class LoadData extends HomeShoppingEvent {
  List<CommonModel> tabList = [];

  LoadData(this.tabList);
}

class ChangeIndex extends HomeShoppingEvent {
  final int selectedIndex;

  ChangeIndex(this.selectedIndex);
}

class LoadProduct extends HomeShoppingEvent {
  final String catId;

  LoadProduct(this.catId);
}
