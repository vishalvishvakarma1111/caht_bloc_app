part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {
  final int index;

  const DashboardState(this.index);
}

class DashboardInitial extends DashboardState {
  const DashboardInitial(super.index);
}
