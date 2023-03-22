import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bloc_app/extention.dart';
import 'package:chat_bloc_app/model/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/common.dart';
import '../../../util/util.dart';
import 'add_product_bloc.dart';
import 'add_product_event.dart';
import 'add_product_state.dart';

class AddProductView extends StatefulWidget {
  final Product? item;

  const AddProductView({Key? key, this.item}) : super(key: key);

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  AddProductBloc addProductBloc = AddProductBloc();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final stockQtyController = TextEditingController();

  @override
  void initState() {
    addProductBloc.add(LoadCategoryEvent(list: const [], loadData: true));
    if (widget.item != null) {
      titleController.text = widget.item?.title ?? "";
      priceController.text = widget.item?.price.toString() ?? "";
      stockQtyController.text = widget.item?.stockQty ?? "";

      widget.item?.colorList?.forEach((element) {
        for (var element2 in addProductBloc.colorList) {
          if (element.value == element2.color?.value) {
            element2.isChecked = true;
          }
        }
      });

      widget.item?.sizeList?.forEach((element) {
        for (var element2 in addProductBloc.sizeList) {
          if (element == element2.productSize) {
            element2.isChecked = true;
          }
        }
      });

      List<CommonModel> photoList = [];

      widget.item?.photoList?.forEach((element) {
        photoList.add(CommonModel(url: element));
      });

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await Future.delayed(const Duration(milliseconds: 1200));
        addProductBloc.add(InitialDataToUpdateEvent(
          selectedCategoryId: widget.item?.categoryId ?? "",
          colorList: addProductBloc.colorList,
          sizeList: addProductBloc.sizeList,
          photoList: photoList,
        ));
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => addProductBloc,
      child: BlocConsumer<AddProductBloc, AddProductState>(
        listener: (context, state) {
          if (state is ErrorState) {
            Util.showToast(state.errorMsg);
          } else if (state is AddProductSuccess) {
            Util.showToast("Product ${widget.item == null ? "added" : "update"} successful");
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text("${widget.item == null ? "Add" : "Update"}Product")),
            body: Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Product Category",
                        style: TextStyle(),
                      ),
                    ),
                    state is ProductLoadedState && state.categoryList.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButton<CommonModel>(
                              borderRadius: BorderRadius.circular(20),
                              underline: const SizedBox.shrink(),
                              isExpanded: true,
                              value: state.selectedCategory,
                              hint: Text(
                                "Select category",
                                style: const TextStyle().semiBold,
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black,
                              ),
                              items: state.categoryList.map((CommonModel? items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items?.title ?? '',
                                    style: const TextStyle().semiBold.copyWith(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (CommonModel? newValue) {
                                BlocProvider.of<AddProductBloc>(context).add(ChangeCategoryEvent(newValue));
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Product Size",
                        style: TextStyle(),
                      ),
                    ),
                    state is ProductLoadedState && (state.sizeList ?? []).isNotEmpty
                        ? Wrap(
                            children: List.generate(
                              (state.sizeList ?? []).length,
                              (index) {
                                var item = (state.sizeList ?? [])[index];
                                return InkWell(
                                  borderRadius: BorderRadius.circular(40),
                                  onTap: () => BlocProvider.of<AddProductBloc>(context).add(
                                    ChangeSizeEvent(index),
                                  ),
                                  child: Chip(
                                    elevation: 20,
                                    padding: const EdgeInsets.all(3),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                    backgroundColor: (item.isChecked ?? false) ? Colors.blue : Colors.grey,
                                    shadowColor: Colors.black,
                                    label: Text(
                                      item.productSize ?? "",
                                      style: const TextStyle().semiBold.copyWith(color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Product Color",
                        style: TextStyle(),
                      ),
                    ),
                    state is ProductLoadedState && (state.colorList ?? []).isNotEmpty
                        ? Wrap(
                            children: List.generate(
                              state.colorList!.length,
                              (index) {
                                var item = (state.colorList ?? [])[index];
                                return InkWell(
                                  borderRadius: BorderRadius.circular(40),
                                  onTap: () => BlocProvider.of<AddProductBloc>(context).add(ChangeColorEvent(index)),
                                  child: Chip(
                                      elevation: 20,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                      backgroundColor: (state.colorList ?? [])[index].color,
                                      shadowColor: Colors.black,
                                      label: Icon(
                                        Icons.check,
                                        size: 20,
                                        color: (item.isChecked ?? false) ? Colors.black : item.color,
                                      ) //Text
                                      ),
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                    state is ProductLoadedState && (state.photoList ?? []).isNotEmpty
                        ? Wrap(
                            children: List.generate(
                              state.photoList?.length ?? 0,
                              (index) {
                                var item = (state.photoList ?? [])[index];
                                return Container(
                                  width: 100,
                                  height: 100,
                                  margin: const EdgeInsets.only(right: 15),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: item.file != null
                                      ? Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.file(
                                              item.file ?? File(''),
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: IconButton(
                                                onPressed: () {
                                                  BlocProvider.of<AddProductBloc>(context).add(RemoveImage(index));
                                                },
                                                color: Colors.white,
                                                icon: const Icon(
                                                  Icons.close,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : item.url != null
                                          ? Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: item.url ?? "",
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder:
                                                      (BuildContext context, String url, DownloadProgress progress) {
                                                    return const Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  },
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: item.loader ?? false
                                                      ? const Center(
                                                          child: SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child: CircularProgressIndicator()),
                                                        )
                                                      : IconButton(
                                                          onPressed: () {
                                                            BlocProvider.of<AddProductBloc>(context).add(
                                                                RemoveImageFromFirebase(index, widget.item?.id ?? ''));
                                                          },
                                                          color: Colors.white,
                                                          icon: const Icon(
                                                            Icons.close,
                                                          ),
                                                        ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                    MaterialButton(
                      height: 30,
                      onPressed: () {
                        showMyPicker(context);
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        "Add Photos",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 20, height: 20),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Enter title",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          constraints: const BoxConstraints(minHeight: 45, maxHeight: 45),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          filled: true,
                          constraints: const BoxConstraints(minHeight: 45, maxHeight: 45),
                          hintText: "Enter Price",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: stockQtyController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          filled: true,
                          constraints: const BoxConstraints(minHeight: 45, maxHeight: 45),
                          hintText: "Enter Stock Qty",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                    ),
                    const SizedBox(height: 60),
                    state is LoadingState
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : MaterialButton(
                            height: 45,
                            minWidth: double.maxFinite,
                            onPressed: () {
                              /// add product
                              if (widget.item == null) {
                                BlocProvider.of<AddProductBloc>(context).add(AddProduct(
                                  price: priceController.text.trim(),
                                  title: titleController.text.trim(),
                                  stockQty: stockQtyController.text.trim(),
                                  state: state as ProductLoadedState,
                                ));
                              } else {
                                /// update product
                                BlocProvider.of<AddProductBloc>(context).add(UpdateProductTap(
                                  oldTitle: widget.item?.title ?? '',
                                  item: state is ProductLoadedState ? state.selectedCategory : null,
                                  title: titleController.text.trim(),
                                  id: widget.item?.id ?? "",
                                  price: priceController.text.trim(),
                                  state: state as ProductLoadedState,
                                  stockQty: stockQtyController.text.trim(),
                                ));
                              }
                            },
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showMyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _imgFromCameraAndGallery(false, context);
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _imgFromCameraAndGallery(true, context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future _imgFromCameraAndGallery(
    bool fromCamera,
    BuildContext context,
  ) async {
    final picker = ImagePicker();
    picker.pickImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery, imageQuality: 50).then(
      (pickedFile) {
        if (pickedFile != null) {
          context.read<AddProductBloc>().add(
                AddPictureEvent(
                  File(pickedFile.path),
                ),
              );
        }
      },
    );
  }
}
