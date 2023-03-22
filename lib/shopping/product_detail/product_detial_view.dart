import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bloc_app/extention.dart';
import 'package:chat_bloc_app/model/products.dart';
import 'package:chat_bloc_app/shopping/product_detail/bloc/product_detail_bloc.dart';
import 'package:chat_bloc_app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util/const.dart';
import '../buy_now/buy_now.dart';

class ProductDetailView extends StatelessWidget {
  final Product item;

  const ProductDetailView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductDetailBloc>(
      create: (context) => ProductDetailBloc()..add(InitialEvent(item)),
      child: BlocConsumer<ProductDetailBloc, ProductDetailState>(
        listener: (context, state) {
          if (state is ProductDetailErrorState) {
            Util.showToast(state.msg);
          }
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                'Product details',
                style: const TextStyle().semiBold.copyWith(color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: item.photoList?.length,
                            itemBuilder: (context, index) => CachedNetworkImage(
                                  height: MediaQuery.of(context).size.height * 0.6,
                                  imageUrl: item.photoList![index] ?? '',
                                  errorWidget: (
                                    BuildContext context,
                                    String url,
                                    dynamic error,
                                  ) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (BuildContext context, String url, DownloadProgress progress) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                )),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title ?? '',
                              style: const TextStyle().semiBold.copyWith(color: Colors.white, fontSize: 30),
                            ),
                            SizedBox(width: 20, height: MediaQuery.of(context).size.height * 0.01),
                            Text(
                              'Price',
                              style: const TextStyle().semiBold.copyWith(color: Colors.white),
                            ),
                            Text(
                              '\$ ${item.price.toString()}',
                              style: const TextStyle().semiBold.copyWith(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  bottomArea(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget addRemoveItem(BuildContext context, ProductDetailLoaded state) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 30,
                child: OutlinedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () {
                    BlocProvider.of<ProductDetailBloc>(context).add(AddRemoveEvent(false, item));
                  },
                  child: const Icon(
                    Icons.remove,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  state.cartItemCount.toString(),
                  style: const TextStyle().normal.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
              SizedBox(
                width: 40,
                height: 30,
                child: OutlinedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () {
                    BlocProvider.of<ProductDetailBloc>(context).add(AddRemoveEvent(true, item));
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () => BlocProvider.of<ProductDetailBloc>(context).add(AddToCartEvent(item)),
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: state.isAddedToCart ?? false ? Colors.pink.shade400 : Colors.grey,
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget colorSize(BuildContext context, ProductDetailLoaded state) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Color",
                style: const TextStyle().normal.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Wrap(
                children: List.generate(
                    item.colorList?.length ?? 0,
                    (index) => InkWell(
                          onTap: () {
                            BlocProvider.of<ProductDetailBloc>(context).add(SelectColorEvent(index));
                          },
                          child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: index == state.colorIndex ? (item.colorList![index]) : Colors.transparent,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.circle,
                                size: 16,
                                color: (item.colorList![index]),
                              )),
                        )),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Size",
                style: const TextStyle().normal.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Row(
                children: List.generate(
                  item.sizeList?.length ?? 0,
                  (index) => InkWell(
                    onTap: () => BlocProvider.of<ProductDetailBloc>(context).add(SelectSizeEvent(index)),
                    child: Container(
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: index == state.sizeIndex ? Colors.black : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        item.sizeList![index],
                        style: const TextStyle().semiBold.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget bottomArea(BuildContext context, ProductDetailState state) {
    return state is ProductDetailLoaded
        ? Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 20, height: 60),
                colorSize(context, state),
                const SizedBox(width: 20, height: 20),
                Text(
                  item.description ?? '',
                  style: const TextStyle(),
                ),
                addRemoveItem(context, state),
                const SizedBox(width: 20, height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: state.loader ?? false
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                              return BuyScreen(
                                product: item,
                                cartCount: state.cartItemCount ?? 0,
                                colorIndex: state.colorIndex ?? 0,
                                sizeIndex: state.sizeIndex ?? 0,
                              );
                            }));
                          },
                          child: Text(
                            "Buy Now",
                            style: const TextStyle().semiBold.copyWith(color: Colors.white),
                          ),
                        ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
