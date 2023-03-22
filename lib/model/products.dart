import 'package:chat_bloc_app/util/const.dart';
import 'package:flutter/material.dart';

class Product {
  final String? image, title, description, id, size;
  final int? price;

  final int? color;
  List<Color>? colorList;
  List<String>? sizeList;
  List<String>? photoList;
  String? stockQty;
  String? categoryId;

  Product({
    this.id,
    this.image,
    this.title,
    this.price,
    this.description,
    this.size,
    this.color,
    this.stockQty,
    this.sizeList,
    this.colorList,
    this.categoryId,
    this.photoList,
  });

  factory Product.fromMap(Map<String, dynamic> map, id) {
    var colorList1 = map[FireKeys.colorList] ?? [];
    var photoList1 = map[FireKeys.photoList] ?? [];
    List<Color> colorList2 = [];
    List<String> photoList2 = [];

    for (var element in photoList1) {
      photoList2.add(element[FireKeys.photo]);
    }

    for (var element in colorList1) {
      colorList2.add(Color(element[FireKeys.color]));
    }
    var sizeList1 = map[FireKeys.sizeList] ?? [];
    List<String> sizeList12 = [];

    for (var element in sizeList1) {
      sizeList12.add(element[FireKeys.size]);
    }

    return Product(
      title: map['title'],
      description: map['description'],
      price: int.parse(map['price'] ?? ''),
      size: map['size'] ?? '',
      id: id,
      colorList: colorList2,
      color: map['color'],
      sizeList: sizeList12,
      stockQty: map[FireKeys.stockQty],
      categoryId: map[FireKeys.categoryId],
      photoList: photoList2,
    );
  }

  @override
  String toString() {
    return 'Product{image: $image, title: $title, description: $description, id: $id, price: $price, size: $size, color: $color, colorList: $colorList, sizeList: $sizeList, stockQty: $stockQty}';
  }
}

List<Color> colors = [
  const Color(0xFF3D82AE),
  const Color(0xFFD3A984),
  const Color(0xFF989493),
  const Color(0xFFE6B398),
  const Color(0xFFFB7883),
  const Color(0xFFAEAEAE),
];

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
