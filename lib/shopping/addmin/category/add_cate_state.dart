part of 'add_cate_bloc.dart';

@immutable
abstract class AddCateState {}

class AddCateInitial extends AddCateState {}

class LoadingState extends AddCateState {}

class ErrorState extends AddCateState {
  final String errorMsg;

  ErrorState({required this.errorMsg});
}

class AddCateSuccess extends AddCateState {}
