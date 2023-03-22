import 'package:chat_bloc_app/extention.dart';
import 'package:chat_bloc_app/model/products.dart';
import 'package:chat_bloc_app/shopping/addmin/category/add_cate_view.dart';
import 'package:chat_bloc_app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../products/add_product_view.dart';
import 'bloc/products_bloc.dart';

class ProductsListView extends StatelessWidget {
  const ProductsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsListBloc()..add(ProductsListLoadEvent(const [])),
      child: BlocConsumer<ProductsListBloc, ProductsListState>(
        listener: (context, state) {
          if (state is FailureState) {
            Util.showToast(state.errorMsf);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: getAppBar(context, state),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const AddProductView();
                  }),
                );
              },
              child: const Icon(Icons.add),
            ),
            body: Container(
              child: state is LoaderState
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : state is ProductsListLoaded
                      ? state.productList.isEmpty
                          ? const Center(
                              child: Text("No Products added yet"),
                            )
                          : ListView.builder(
                              itemCount: state.productList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var item = state.productList[index];

                                return ListTile(
                                  title: Text(
                                    item.title ?? "",
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: Text(
                                    item.description ?? "",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  title: const Text("Alert!"),
                                                  content: const Text("Edit Products"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () => Navigator.pop(context), child: const Text("No")),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                          Navigator.push(context,
                                                              MaterialPageRoute(builder: (BuildContext context) {
                                                                return AddProductView(item: item);
                                                              }));
                                                        },
                                                        child: const Text("Yes")),
                                                  ]);
                                            },
                                          );
                                        },
                                      ),


                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext dialogContext) {
                                                return AlertDialog(
                                                  title: const Text("Alert!"),
                                                  content: const Text("Delete"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text("No")),
                                                    TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(context);

                                                          BlocProvider.of<ProductsListBloc>(context).add(
                                                            ProductsListDeleteEvent(
                                                              item: item,
                                                              list: state.productList,
                                                            ),
                                                          );
                                                        },
                                                        child: const Text("Yes"))
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                      : const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}

PreferredSizeWidget getAppBar(BuildContext context, ProductsListState state) {
  return AppBar(
    title: const Text(
      "ProductsList",
    ),
  );
}
