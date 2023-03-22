import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_bloc_app/util/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../model/products.dart';
import '../../../util/firebase_util.dart';

part 'product_detail_event.dart';

part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(ProductDetailInitial()) {
    on<ProductDetailEvent>((event, emit) {});
    on<InitialEvent>(_initial);
    on<SelectSizeEvent>(_selectSize);
    on<SelectColorEvent>(_selectColor);
    on<AddToCartEvent>(_addToCart);
    on<AddRemoveEvent>(_addRemove);
    on<BuyEvent>(_buyProduct);
  }

  FutureOr<void> _initial(InitialEvent event, Emitter<ProductDetailState> emit) async {
    emit(ProductDetailLoaded(cartItemCount: 1, colorIndex: 0, sizeIndex: 0));

    QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance
        .collection(cartTable)
        .where(
          FireKeys.productId,
          isEqualTo: event.product.id,
        )
        .where(FireKeys.userId, isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
        .get();

    emit(ProductDetailLoaded(cartItemCount: 1, colorIndex: 0, sizeIndex: 0, isAddedToCart: result.docs.isNotEmpty));
  }

  FutureOr<void> _selectSize(SelectSizeEvent event, Emitter<ProductDetailState> emit) {
    ProductDetailLoaded oldState = state as ProductDetailLoaded;

    emit(oldState.copyWith(sizeIndex: event.index));
  }

  FutureOr<void> _selectColor(SelectColorEvent event, Emitter<ProductDetailState> emit) {
    ProductDetailLoaded oldState = state as ProductDetailLoaded;

    emit(oldState.copyWith(colorIndex: event.index));
  }

  FutureOr<void> _addToCart(AddToCartEvent event, Emitter<ProductDetailState> emit) async {
    ProductDetailLoaded oldState = state as ProductDetailLoaded;
    emit(
      oldState.copyWith(
        isAddedToCart: !(oldState.isAddedToCart ?? false),
      ),
    );
    try {
      if (!(oldState.isAddedToCart ?? false)) {
        await FirebaseFirestore.instance.collection(cartTable).add(
          {
            FireKeys.userId: FirebaseAuth.instance.currentUser?.uid ?? '',
            FireKeys.title: event.product.title,
            FireKeys.productId: event.product.id,
            FireKeys.color: event.product.colorList![oldState.colorIndex ?? 0].value,
            FireKeys.size: event.product.sizeList![oldState.sizeIndex ?? 0],
            FireKeys.price: event.product.price.toString(),
          },
        );
      } else {
        QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance
            .collection(cartTable)
            .where(
              FireKeys.productId,
              isEqualTo: event.product.id,
            )
            .where(FireKeys.userId, isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
            .get();
        await FirebaseFirestore.instance.collection(cartTable).doc(result.docs.first.id).delete();
      }
      emit(
        oldState.copyWith(
          isAddedToCart: !(oldState.isAddedToCart ?? false),
        ),
      );
    } catch (e) {
      print(e);
      emit(ProductDetailErrorState(e.toString()));
      emit(oldState.copyWith());
    }
  }

  FutureOr<void> _buyProduct(BuyEvent event, Emitter<ProductDetailState> emit) {}

  FutureOr<void> _addRemove(AddRemoveEvent event, Emitter<ProductDetailState> emit) {
    ProductDetailLoaded oldState = state as ProductDetailLoaded;
    if (event.isAdd) {
      if (int.parse(event.product.stockQty ?? '0') > (oldState.cartItemCount ?? 0)) {
        emit(oldState.copyWith(cartItemCount: (oldState.cartItemCount ?? 0) + 1));
      } else {
        emit(ProductDetailErrorState('No more Item left'));
        emit(oldState.copyWith());
      }
    } else {
      if (oldState.cartItemCount! > 0) {
        emit(oldState.copyWith(cartItemCount: (oldState.cartItemCount ?? 0) - 1));
      }
    }
  }
}
