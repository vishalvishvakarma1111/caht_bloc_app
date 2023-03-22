import 'package:chat_bloc_app/extention.dart';
import 'package:chat_bloc_app/shopping/addmin/category/add_cate_view.dart';
import 'package:chat_bloc_app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_product/products_view.dart';
import 'bloc/catelist_bloc.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryListBloc()..add(CategoryListLoadEvent(const [])),
      child: BlocConsumer<CategoryListBloc, CategoryListState>(
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
                    return const AddCateView();
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
                  : state is CategoryListLoaded
                      ? state.categoryList.isEmpty
                          ? const Center(
                              child: Text("No Category added yet"),
                            )
                          : ListView.builder(
                              itemCount: state.categoryList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var item = state.categoryList[index];

                                return ListTile(
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Text("Alert!"),
                                            content: const Text("Edit Category"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () => Navigator.pop(context), child: const Text("No")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(context,
                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                      return AddCateView(item: item);
                                                    }));
                                                  },
                                                  child: const Text("Yes")),
                                            ]);
                                      },
                                    );
                                  },
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
                                  trailing: IconButton(
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

                                                      BlocProvider.of<CategoryListBloc>(context).add(
                                                        CategoryListDeleteEvent(
                                                          item: item,
                                                          list: state.categoryList,
                                                        ),
                                                      );
                                                    },
                                                    child: const Text("Yes"))
                                              ],
                                            );
                                          });
                                    },
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

PreferredSizeWidget getAppBar(BuildContext context, CategoryListState state) {
  return AppBar(
    title: const Text(
      "CategoryList",
    ),
    actions: [
      TextButton(
        onPressed: () {
          Util.go(context, const ProductsListView());
        },
        child: Text(
          "Products",
          style: const TextStyle().semiBold.copyWith(color: Colors.white),
        ),
      ),
    ],
  );
}
