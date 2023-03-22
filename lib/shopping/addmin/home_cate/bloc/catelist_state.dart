part of 'catelist_bloc.dart';

@immutable
abstract class CategoryListState {}

class CategoryListInitial extends CategoryListState {}

class LoaderState extends CategoryListState {}

class FailureState extends CategoryListState {
  final String errorMsf;

  FailureState({required this.errorMsf});
}

class CategoryListLoaded extends CategoryListState {
  List<CommonModel> categoryList;

  CategoryListLoaded({required this.categoryList});
}
