part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeError extends HomeState {
  final String msg;

  HomeError(this.msg);
}

class HomeLoadedState extends HomeState {
  final bool? loader;
  final bool? logout;
  final bool? logoutLoader;

  HomeLoadedState({this.loader, this.logout, this.logoutLoader});

  HomeLoadedState copyWith({
    bool? loader,
    bool? logout,
    bool? logoutLoader,
    List<UserModel>? usersList,
  }) {
    return HomeLoadedState(
      loader: loader ?? this.loader,
      logout: logout ?? this.logout,
      logoutLoader: logoutLoader ?? this.logoutLoader,
    );
  }
}
