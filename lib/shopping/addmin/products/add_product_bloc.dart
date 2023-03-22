import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat_bloc_app/util/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../model/common.dart';
import '../../../util/firebase_util.dart';
import 'add_product_event.dart';
import 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  List<CommonModel> colorList = [
    CommonModel(color: Colors.red.shade300, isChecked: false),
    CommonModel(color: Colors.lime, isChecked: false),
    CommonModel(color: Colors.pinkAccent, isChecked: false),
    CommonModel(color: Colors.deepOrangeAccent, isChecked: false),
    CommonModel(color: Colors.purpleAccent, isChecked: false),
  ];

  List<CommonModel> sizeList = [
    CommonModel(productSize: 'S', isChecked: false),
    CommonModel(productSize: 'M', isChecked: false),
    CommonModel(productSize: 'L', isChecked: false),
    CommonModel(productSize: 'XL', isChecked: false),
    CommonModel(productSize: 'XXl', isChecked: false),
  ];

  CollectionReference productCollection = FirebaseFirestore.instance.collection(productTable);
  CollectionReference categoryCollection = FirebaseFirestore.instance.collection(categoryTable);

  AddProductBloc() : super(AddProductInitial()) {
    on<AddProductEvent>((event, emit) {});
    on<AddProduct>(_onSubmit);
    on<UpdateProductTap>(_onUpdateProduct);
    on<LoadCategoryEvent>(_loadCategory);
    on<ChangeCategoryEvent>(_selectCategory);
    on<ChangeSizeEvent>(_selectSize);
    on<ChangeColorEvent>(_selectColor);
    on<InitialDataToUpdateEvent>(_setInitialData);
    on<AddPictureEvent>(_setPhotos);
    on<RemoveImage>(_deletePhoto);
    on<RemoveImageFromFirebase>(_removePhotoFromFirebase);
  }

  Future<FutureOr<void>> _onSubmit(AddProduct event, Emitter<AddProductState> emit) async {
    // final result =
    //     await FirebaseFirestore.instance.collection(productTable).where('title', isEqualTo: event.title).get();
    ProductLoadedState oldState = state as ProductLoadedState;
    String title = '';
    // if (result.docs.isNotEmpty) {
    //   title = result.docs.first.data()['title'];
    // }
    var checkedSizedList = event.state.sizeList?.where((element) => (element.isChecked ?? false)).toList();
    var checkedColorList = event.state.colorList?.where((element) => (element.isChecked ?? false)).toList();
    var photoList = oldState.photoList;

    if (event.state.selectedCategory == null) {
      emit(ErrorState(errorMsg: "Please select category"));
      emit(ProductLoadedState(
        categoryList: oldState.categoryList,
      ));
    } else if (checkedSizedList?.isEmpty ?? true) {
      emit(ErrorState(errorMsg: "Please select any size"));
      emit(oldState.copyWith());
    } else if (checkedColorList?.isEmpty ?? true) {
      emit(ErrorState(errorMsg: "Please select any color"));
      emit(oldState.copyWith());
    } else if (photoList?.isEmpty ?? true) {
      emit(ErrorState(errorMsg: "Please add at least one photo"));
      emit(oldState.copyWith());
    } else if (event.title.isEmpty) {
      emit(ErrorState(errorMsg: "Please enter title"));
      add(LoadCategoryEvent(list: oldState.categoryList, loadData: false));
    } else if (title == event.title.trim()) {
      emit(ErrorState(errorMsg: "Already added before"));
      emit(oldState.copyWith());
    } else if (event.price.isEmpty) {
      emit(ErrorState(errorMsg: "Please enter price"));
      emit(oldState.copyWith());
    } else {
      emit(LoadingState());
      try {
        List colorList = [];
        List sizeList = [];

        checkedSizedList?.forEach((element) {
          sizeList.add({
            FireKeys.size: element.productSize,
          });
        });
        checkedColorList?.forEach((element) {
          colorList.add({
            FireKeys.color: element.color?.value,
          });
        });

        List photoListKV = [];

        photoListKV = await addImage(photoList ?? []);

        await productCollection.add({
          FireKeys.title: event.title,
          FireKeys.categoryId: event.state.selectedCategory?.id ?? '',
          FireKeys.price: event.price,
          FireKeys.colorList: FieldValue.arrayUnion(colorList),
          FireKeys.sizeList: FieldValue.arrayUnion(sizeList),
          FireKeys.photoList: FieldValue.arrayUnion(photoListKV),
          FireKeys.stockQty: event.stockQty,
          "created_time": DateTime.now().toString(),
        });
        emit(AddProductSuccess());
      } catch (e) {
        log("message---error ", error: e.toString());
        emit(ErrorState(errorMsg: e.toString()));
        emit(oldState.copyWith());
      }
    }
  }

  FutureOr<void> _onUpdateProduct(UpdateProductTap event, Emitter<AddProductState> emit) async {
    ProductLoadedState oldState = state as ProductLoadedState;
    String title = '';

    var checkedSizedList = event.state?.sizeList?.where((element) => (element.isChecked ?? false)).toList();
    var checkedColorList = event.state?.colorList?.where((element) => (element.isChecked ?? false)).toList();
    var photoList = oldState.photoList;

    if (event.state?.selectedCategory == null) {
      emit(ErrorState(errorMsg: "Please select category"));
      emit(oldState.copyWith());
    } else if (checkedSizedList?.isEmpty ?? false) {
      emit(ErrorState(errorMsg: "Please select any size"));
      emit(oldState.copyWith());
    } else if (checkedColorList?.isEmpty ?? false) {
      emit(ErrorState(errorMsg: "Please select any color"));
      emit(oldState.copyWith());
    } else if (oldState.photoList?.isEmpty ?? false) {
      emit(ErrorState(errorMsg: "Please select at least one photo"));
      emit(oldState.copyWith());
    } else if (event.title.isEmpty) {
      emit(ErrorState(errorMsg: "Please enter title"));
      add(LoadCategoryEvent(list: oldState.categoryList, loadData: false));
    } else if (title == event.title.trim()) {
      emit(ErrorState(errorMsg: "Already added before"));
      emit(oldState.copyWith());
    } else if (event.price.isEmpty) {
      emit(ErrorState(errorMsg: "Please enter price"));
      emit(oldState.copyWith());
    } else {
      emit(LoadingState());
      try {
        List colorList = [];
        List sizeList = [];
        List photoListKV = [];

        checkedSizedList?.forEach((element) {
          sizeList.add({
            FireKeys.size: element.productSize,
          });
        });
        checkedColorList?.forEach((element) {
          colorList.add({
            FireKeys.color: element.color?.value,
          });
        });

        photoListKV = await addImage(photoList ?? []);

        await productCollection.doc(event.id).update({
          "update_time": DateTime.now().toString(),
          FireKeys.title: event.title,
          FireKeys.categoryId: event.state?.selectedCategory?.id ?? '',
          FireKeys.price: event.price,
          FireKeys.colorList: FieldValue.arrayUnion(colorList),
          FireKeys.sizeList: FieldValue.arrayUnion(sizeList),
          FireKeys.photoList: FieldValue.arrayUnion(photoListKV),
          FireKeys.stockQty: event.stockQty,
        });
        emit(oldState.copyWith());
        emit(AddProductSuccess());
      } catch (e) {
        emit(ErrorState(errorMsg: e.toString()));
        emit(oldState.copyWith());
        log("message---error ", error: e.toString());
      }
    }
  }

  FutureOr<void> _loadCategory(LoadCategoryEvent event, Emitter<AddProductState> emit) async {
    try {
      if (event.loadData) {
        QuerySnapshot<Object?> res = await categoryCollection.get();
        event.list = [];
        if (res.docs.isEmpty) {
          emit(ProductLoadedState(categoryList: event.list, colorList: colorList, sizeList: sizeList));
        } else {
          for (var element in res.docs) {
            Map<String, dynamic> data = element.data() as Map<String, dynamic>;
            var item = CommonModel.fromMap(data, element.id);
            event.list.add(item);
          }
          emit(ProductLoadedState(
              categoryList: event.list, selectedCategory: event.list.first, colorList: colorList, sizeList: sizeList));
        }
      } else {
        emit(ProductLoadedState(
            categoryList: event.list, selectedCategory: event.list.first, colorList: colorList, sizeList: sizeList));
      }
    } catch (e) {
      print(e);
      emit(ErrorState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> _selectCategory(ChangeCategoryEvent event, Emitter<AddProductState> emit) {
    ProductLoadedState oldState = state as ProductLoadedState;
    emit(oldState.copyWith(selectedCategory: event.item));
  }

  FutureOr<void> _selectSize(ChangeSizeEvent event, Emitter<AddProductState> emit) {
    ProductLoadedState oldState = state as ProductLoadedState;
    (oldState.sizeList ?? [])[event.index].isChecked = !((oldState.sizeList ?? [])[event.index].isChecked ?? false);
    emit(oldState.copyWith(sizeList: oldState.sizeList));
  }

  FutureOr<void> _selectColor(ChangeColorEvent event, Emitter<AddProductState> emit) {
    ProductLoadedState oldState = state as ProductLoadedState;
    (oldState.colorList ?? [])[event.index].isChecked = !((oldState.colorList ?? [])[event.index].isChecked ?? false);
    emit(oldState.copyWith(colorList: oldState.colorList));
  }

  FutureOr<void> _setInitialData(InitialDataToUpdateEvent event, Emitter<AddProductState> emit) {
    ProductLoadedState oldState = state as ProductLoadedState;
    CommonModel? selectedCategory;
    oldState.photoList = event.photoList;
    for (var element in oldState.categoryList) {
      if (element.id == event.selectedCategoryId) {
        selectedCategory = element;
        break;
      }
    }
    emit(oldState.copyWith(selectedCategory: selectedCategory));
  }

  FutureOr<void> _setPhotos(AddPictureEvent event, Emitter<AddProductState> emit) {
    ProductLoadedState oldState = state as ProductLoadedState;
    oldState.photoList ??= [];
    oldState.photoList?.add(CommonModel(file: event.file));

    emit(oldState.copyWith(photoList: oldState.photoList));
  }

  FutureOr<void> _deletePhoto(RemoveImage event, Emitter<AddProductState> emit) {
    ProductLoadedState oldState = state as ProductLoadedState;
    oldState.photoList?.removeAt(event.index);
    emit(oldState.copyWith());
  }

  Future<List> addImage(List<CommonModel> photoList) async {
    List photoListKV = [];

    if (photoList.isNotEmpty) {
      for (var element in photoList) {
        if (element.file != null) {
          String? fileName = element.file?.path.split('/').last;

          final storage = FirebaseStorage.instance.ref().child('products_images/$fileName');
          TaskSnapshot taskSnapshot = await storage.putFile(element.file ?? File(''));
          String url = await taskSnapshot.ref.getDownloadURL();
          photoListKV.add({FireKeys.photo: url});
        }
      }
    }
    return photoListKV;
  }

  FutureOr<void> _removePhotoFromFirebase(RemoveImageFromFirebase event, Emitter<AddProductState> emit) async {
    ProductLoadedState oldState = state as ProductLoadedState;
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String url = oldState.photoList![event.index].url ?? '';
      oldState.photoList![event.index].loader = true;
      emit(oldState.copyWith(photoList: oldState.photoList));
      Reference reference = storage.refFromURL(url);
      await reference.delete();
      final docSnap = await productCollection.doc(event.docId).get();

      List queue = docSnap.get(FireKeys.photoList);
      for (var element in queue) {
        if (element['photo'] == url) {
          queue.remove(element);
          break;
        }
      }

      await productCollection.doc(event.docId).update({
        FireKeys.photoList: queue,
      });
      oldState.photoList?.removeAt(event.index);
      emit(oldState.copyWith(photoList: oldState.photoList));
    } catch (e) {
      emit(ErrorState(errorMsg: e.toString()));
      emit(oldState.copyWith(photoList: oldState.photoList));

      print(e);
    }
  }
}
