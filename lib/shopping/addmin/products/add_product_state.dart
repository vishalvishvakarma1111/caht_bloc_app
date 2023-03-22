import 'package:flutter/material.dart';

import '../../../model/common.dart';

@immutable
abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class LoadingState extends AddProductState {}

class ErrorState extends AddProductState {
  final String errorMsg;

  ErrorState({required this.errorMsg});
}

class ProductLoadedState extends AddProductState {
  final List<CommonModel> categoryList;
  CommonModel? selectedCategory;
  String? selectedSize;

  final List<CommonModel>? sizeList;

  List<CommonModel>? colorList;
  List<CommonModel>? photoList;

  ProductLoadedState({
    required this.categoryList,
    this.selectedCategory,
    this.colorList,
    this.sizeList,
    this.photoList,
  });

  ProductLoadedState copyWith({
    List<CommonModel>? categoryList,
    CommonModel? selectedCategory,
    List<CommonModel>? colorList,
    List<CommonModel>? sizeList,
    List<CommonModel>? photoList,
  }) {
    return ProductLoadedState(
      categoryList: categoryList ?? this.categoryList,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      colorList: colorList ?? this.colorList,
      sizeList: sizeList ?? this.sizeList,
      photoList: photoList ?? this.photoList,
    );
  }
}

class AddProductSuccess extends AddProductState {}
