import 'dart:io';
import 'dart:ui';

import 'package:chat_bloc_app/util/const.dart';

class CommonModel {
  String? title, description, title2, title3, title4, id, price, stockQty, url;
  String? productSize;
  Color? color;
  File? file;

  bool? loader;

  bool? isChecked;

  CommonModel({
    this.title,
    this.description,
    this.title2,
    this.title3,
    this.title4,
    this.id,
    this.price,
    this.stockQty,
    this.productSize,
    this.isChecked,
    this.color,
    this.url,
    this.file,
    this.loader,
  });

  factory CommonModel.fromMap(Map<String, dynamic> map, String id) {
    print("-----print-----   ${map[FireKeys.photoList]}");
    return CommonModel(
      title: map[FireKeys.title] ?? '',
      description: map[FireKeys.desc] ?? '',
      title2: map['title2'] ?? '',
      title3: map['title3'] ?? '',
      title4: map['title4'] ?? '',
      id: id,
      price: map[FireKeys.price] ?? '',
      stockQty: map[FireKeys.stockQty] ?? '',
    );
  }

  @override
  String toString() {
    return 'CommonModel{title: $title, description: $description, title2: $title2, title3: $title3, title4: $title4, id: $id, price: $price, stockQty: $stockQty, url: $url, productSize: $productSize, color: $color, file: $file, isChecked: $isChecked}';
  }
}
