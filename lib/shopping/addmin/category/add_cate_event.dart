part of 'add_cate_bloc.dart';

@immutable
abstract class AddCateEvent {}

class AddCate extends AddCateEvent {
  final String title;

  AddCate({required this.title});
}

class UpdateNotesTap extends AddCateEvent {
  final String title, id;

  UpdateNotesTap({required this.title, required this.id});
}
