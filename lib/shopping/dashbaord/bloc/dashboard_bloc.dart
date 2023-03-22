import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardInitial(0)) {
    on<DashboardEvent>((event, emit) {});
    on<SetIndex>((event, emit) {
      emit(DashboardInitial(event.index));
    });
  }
}
