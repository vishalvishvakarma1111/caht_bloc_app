part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {}

class SetIndex extends DashboardEvent {
  final int index;

  SetIndex(this.index);
}
