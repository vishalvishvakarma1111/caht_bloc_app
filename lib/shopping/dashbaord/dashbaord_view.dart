import 'package:chat_bloc_app/shopping/dashbaord/bloc/dashboard_bloc.dart';
import 'package:chat_bloc_app/shopping/home_shopping/home_shopping_view.dart';
import 'package:chat_bloc_app/user_profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cart/cart_view.dart';

class DashBoardView extends StatelessWidget {
  final widgetList = [const HomeViewShopping(), const CartView(), ProfileView()];

  DashBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(),
      child: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: widgetList[state.index],
            bottomNavigationBar: _bottomNavigationBar(context, state),
          );
        },
      ),
    );
  }

  _bottomNavigationBar(BuildContext context, DashboardState state) {
    return BottomNavigationBar(
        currentIndex: state.index,
        onTap: (int index) {
          BlocProvider.of<DashboardBloc>(context).add(SetIndex(index));
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Cart',
            icon: Icon(
              Icons.shopping_cart_outlined,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(
              Icons.person,
            ),
          ),
        ]);
  }
}
