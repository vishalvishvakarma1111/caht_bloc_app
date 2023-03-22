import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bloc_app/extention.dart';
import 'package:chat_bloc_app/model/products.dart';
import 'package:chat_bloc_app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dashbaord/dashbaord_view.dart';
import 'bloc/buy_now_bloc.dart';

class BuyScreen extends StatelessWidget {
  final Product product;
  final int cartCount;
  final int sizeIndex;
  final int colorIndex;

  const BuyScreen({
    Key? key,
    required this.product,
    required this.cartCount,
    required this.colorIndex,
    required this.sizeIndex,
  }) : super(key: key);

  Widget get _loader => const Center(
        child: CircularProgressIndicator(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuyNowBloc()..add(LoadAddressEvent()),
      child: BlocConsumer<BuyNowBloc, BuyNowState>(
        listener: (context, state) {
          if (state is BuyNowErrorState) {
            Util.showToast(state.msg);
          } else if (state is BuySuccessState) {
            Util.showToast('Order placed successfully');
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return DashBoardView();
              },
            ), (route) => false);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Buy ${product.title}'),
            ),
            body: state is BuyNowLoaded
                ? Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.3,
                            imageUrl: product.photoList?.first ?? '',
                            errorWidget: (
                              BuildContext context,
                              String url,
                              dynamic error,
                            ) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (BuildContext context, String url, DownloadProgress progress) {
                              return _loader;
                            },
                          ),
                        ),
                        const SizedBox(width: 20, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Product: ${product.title}',
                                style: const TextStyle().bold,
                              ),
                            ),
                            Text(
                              'Qty: $cartCount',
                              style: const TextStyle().bold,
                            ),
                          ],
                        ),
                        const SizedBox(width: 20, height: 10),
                        colorSize(context, state),
                        const SizedBox(width: 20, height: 10),
                        Expanded(
                          child: state.addressList?.isEmpty ?? true
                              ? Center(
                                  child: Text(
                                    "No Address found",
                                    style: const TextStyle().bold,
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.addressList?.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    var item = (state.addressList ?? [])[index];
                                    return InkWell(
                                      onTap: () {
                                        context.read<BuyNowBloc>().add(ChangeIndexEvent(index));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: state.selectedAddressIndex == index
                                                  ? Colors.grey
                                                  : Colors.transparent),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            item.address ?? '',
                                            style: const TextStyle().bold,
                                          ),
                                          subtitle: Text(
                                            item.city ?? '',
                                            style: const TextStyle().semiBold,
                                          ),
                                          trailing: Text(
                                            item.zipCode ?? '',
                                            style: const TextStyle().bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Text(
                          "Cash On Delivery",
                          style: const TextStyle().bold,
                        ),
                        const SizedBox(width: 20, height: 20),
                        state.buyLoader ?? false
                            ? _loader
                            : ElevatedButton(
                                onPressed: () => context.read<BuyNowBloc>().add(BuyEvent(
                                      product: product,
                                      size: product.sizeList![sizeIndex],
                                      color: product.colorList![colorIndex].value.toString(),
                                      qty: cartCount,
                                      address: state.addressList![state.selectedAddressIndex ?? 0],
                                    )),
                                child: const Text('Buy now'),
                              ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget colorSize(BuildContext context, BuyNowLoaded state) {
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
              Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (product.colorList![colorIndex]),
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.circle,
                    size: 16,
                    color: (product.colorList![colorIndex]),
                  )),
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
              Container(
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Text(
                  product.sizeList![sizeIndex],
                  style: const TextStyle().semiBold.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
