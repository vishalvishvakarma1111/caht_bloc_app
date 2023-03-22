import 'dart:io';

import 'package:chat_bloc_app/shopping/addmin/products/add_product_state.dart';
import 'package:flutter/material.dart';

import '../../../model/common.dart';

@immutable
abstract class AddProductEvent {}

class AddProduct extends AddProductEvent {
  final String title;
  final String price;
  final String stockQty;
  ProductLoadedState state;

  AddProduct({
    required this.title,
    required this.price,
    required this.state,
    required this.stockQty,
  });
}

class UpdateProductTap extends AddProductEvent {
  final String title, id, price, stockQty, oldTitle;
  final CommonModel? item;
  final ProductLoadedState? state;

  UpdateProductTap({
    required this.title,
    required this.id,
    required this.item,
    required this.price,
    required this.state,
    required this.stockQty,
    required this.oldTitle,
  });
}

class LoadCategoryEvent extends AddProductEvent {
  List<CommonModel> list;
  bool loadData;

  LoadCategoryEvent({
    required this.list,
    required this.loadData,
  });
}

class ChangeCategoryEvent extends AddProductEvent {
  final CommonModel? item;

  ChangeCategoryEvent(this.item);
}

class ChangeSizeEvent extends AddProductEvent {
  final int index;

  ChangeSizeEvent(this.index);
}

class ChangeColorEvent extends AddProductEvent {
  final int index;

  ChangeColorEvent(this.index);
}

class InitialDataToUpdateEvent extends AddProductEvent {
  final List<CommonModel>? colorList;
  final List<CommonModel>? sizeList;
  final List<CommonModel>? photoList;
  final String? selectedCategoryId;

  InitialDataToUpdateEvent({
    this.colorList,
    this.sizeList,
    this.selectedCategoryId,
    this.photoList,
  });
}

class AddPictureEvent extends AddProductEvent {
  File file;

  AddPictureEvent(this.file);
}

class RemoveImage extends AddProductEvent {
  final int index;

  RemoveImage(this.index);
}

class RemoveImageFromFirebase extends AddProductEvent {
  final int index;
  final String docId;

  RemoveImageFromFirebase(this.index, this.docId);
}
