import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bloc_app/extention.dart';
import 'package:chat_bloc_app/shopping/product_detail/product_detial_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../util/const.dart';
import '../../util/util.dart';
import 'bloc/home_shopping_bloc.dart';
import 'bloc/home_shopping_state.dart';

class HomeViewShopping extends StatefulWidget {
  const HomeViewShopping({Key? key}) : super(key: key);

  @override
  State<HomeViewShopping> createState() => _HomeViewShoppingState();
}

class _HomeViewShoppingState extends State<HomeViewShopping> with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeShoppingBloc()..add(LoadData([])),
      child: BlocConsumer<HomeShoppingBloc, HomeShoppingState>(
        listener: (context, state) {
          if (state is HomeErrorState) {
            Util.showToast(state.msg);
          }
        },
        builder: (BuildContext context, HomeShoppingState state) {
          return Scaffold(
            appBar: _getAppBar(),
            body: state is HomeLoadedState ? _home(state, context) : const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  _getAppBar() => AppBar(
        title: Text(
          'Shopping',
          style: const TextStyle().bold.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          ),
        ],
      );

  Widget gridview(HomeLoadedState state, BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      itemCount: state.productList?.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
      itemBuilder: (BuildContext context, int index) {
        var item = (state.productList ?? [])[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProductDetailView(item: item);
                },
              ),
            );
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    width: double.maxFinite,
                    height: 190,
                    imageUrl: item.photoList?.first ?? '',
                    errorWidget: (
                      BuildContext context,
                      String url,
                      dynamic error,
                    ) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (BuildContext context, String url, DownloadProgress progress) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20, height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    item.title ?? '',
                    style: const TextStyle().semiBold.copyWith(color: Colors.grey, fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '\$${item.price.toString()}',
                    style: const TextStyle().semiBold.copyWith(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _home(HomeLoadedState state, BuildContext context) {
    controller =
        TabController(length: (state.tabList?.length ?? 0), vsync: this, initialIndex: state.selectedTabIndex ?? 0);
    return Column(
      children: [
        TabBar(
          isScrollable: true,
          indicatorColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.label,
          onTap: (int index) {
            BlocProvider.of<HomeShoppingBloc>(context).add(ChangeIndex(index));
          },
          tabs: (state.tabList ?? [])
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    item.title ?? '',
                    style: const TextStyle().semiBold.copyWith(
                          color: state.selectedTabIndex == state.tabList?.indexOf(item) ? Colors.black : Colors.grey,
                        ),
                  ),
                ),
              )
              .toList(),
          controller: controller,
        ),
        Expanded(
          child: state.loader ?? false
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : gridview(state, context),
        )
      ],
    );
  }
}
