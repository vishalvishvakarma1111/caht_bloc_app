import 'package:chat_bloc_app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/cart_bloc.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc()..add(LoadCartEvent()),
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            Util.showToast(state.msg);
          }
        },
        builder: (context, state) {
          return state is CartLoadedState
              ? Scaffold(
                  appBar: AppBar(
                    title: const Text('Cart'),
                  ),
                  body: state.loader ?? false
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : (state.cartList ?? []).isEmpty || state.cartList == null
                          ? const Center(
                              child: Text('No cart Item found'),
                            )
                          : ListView.separated(
                              itemCount: state.cartList?.length ?? 0,
                              itemBuilder: (context, index) {
                                var item = state.cartList![index];
                                return Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item.title ?? ''),
                                      Text('Price: ${item.price.toString()}'),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        color: Color(item.color ?? 0),
                                      )
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return const Divider();
                              },
                            ),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
