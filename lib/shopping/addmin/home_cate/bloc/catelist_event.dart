part of 'catelist_bloc.dart';

@immutable
abstract class CategoryListEvent {}

class CategoryListLoadEvent extends CategoryListEvent {
  List<CommonModel> list;

  CategoryListLoadEvent(this.list);
}

class CategoryListDeleteEvent extends CategoryListEvent {
  final CommonModel item;

  final List<CommonModel> list;

  CategoryListDeleteEvent({required this.item, required this.list});
}
