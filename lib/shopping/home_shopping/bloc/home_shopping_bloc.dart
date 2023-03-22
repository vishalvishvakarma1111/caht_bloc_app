import 'dart:async';
import 'dart:developer';
import 'package:chat_bloc_app/util/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import '../../../firebase_options.dart';
import '../../../model/common.dart';
import '../../../model/products.dart';
import '../../../util/firebase_util.dart';
import 'home_shopping_state.dart';

part 'home_shopping_event.dart';

class HomeShoppingBloc extends Bloc<HomeShoppingEvent, HomeShoppingState> {
  HomeShoppingBloc() : super(HomeShoppingInitial()) {
    on<HomeShoppingEvent>((event, emit) {});

    on<LoadData>(_loadData);
    on<ChangeIndex>(_changeIndex);
    on<LoadProduct>(_loadProducts);
  }

  FutureOr<void> _loadData(LoadData event, Emitter<HomeShoppingState> emit) async {
    emit(HomeLoadedState(loader: true, selectedTabIndex: 0));
    try {
      initializeService();
      CollectionReference categoryCollection = FirebaseFirestore.instance.collection(categoryTable);
      Stream<QuerySnapshot<Object?>> res = categoryCollection.snapshots();
      HomeLoadedState lastState = state as HomeLoadedState;

      await res.forEach((snapshot) {
        lastState.tabList = [];
        if (snapshot.docs.isEmpty) {
          emit(HomeLoadedState(selectedTabIndex: 0, tabList: const []));
        } else {
          for (var element in snapshot.docs) {
            Map<String, dynamic> data = element.data() as Map<String, dynamic>;
            lastState.tabList?.add(CommonModel.fromMap(data, element.id));
            emit(HomeLoadedState(selectedTabIndex: 0, tabList: lastState.tabList));
          }
          add(LoadProduct(lastState.tabList![0].id ?? ''));
        }
      });
    } catch (e) {
      emit(HomeErrorState(e.toString()));
      print(e);
    }
  }

  initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
        androidConfiguration: AndroidConfiguration(
          // this will be executed when app is in foreground or background in separated isolate
          onStart: onStart,

          autoStart: true,
          isForegroundMode: true,

          initialNotificationTitle: 'AWESOME SERVICE',
          initialNotificationContent: 'Initializing',
        ),
        iosConfiguration: IosConfiguration(
          onBackground: onIosBackground,
          onForeground: onStart,
          autoStart: true
        ));
    service.startService();
  }

  FutureOr<void> _changeIndex(ChangeIndex event, Emitter<HomeShoppingState> emit) {
    HomeLoadedState lastState = state as HomeLoadedState;
    lastState.selectedTabIndex = event.selectedIndex;
    emit(lastState.copyWith(selectedTabIndex: lastState.selectedTabIndex));
    add(LoadProduct(lastState.tabList![event.selectedIndex].id ?? ''));
  }

  FutureOr<void> _loadProducts(LoadProduct event, Emitter<HomeShoppingState> emit) async {
    HomeLoadedState lastState = state as HomeLoadedState;

    emit(lastState.copyWith(loader: true));

    Stream<QuerySnapshot<Object?>> res = FirebaseFirestore.instance
        .collection(productTable)
        .where(
          FireKeys.categoryId,
          isEqualTo: event.catId,
        )
        .snapshots();
    try {
      await res.forEach((snapshot) {
        lastState.productList = [];
        if (snapshot.docs.isEmpty) {
          emit(lastState.copyWith(productList: []));
        } else {
          for (var element in snapshot.docs) {
            Map<String, dynamic> data = element.data() as Map<String, dynamic>;
            lastState.productList?.add(Product.fromMap(data, element.id));
            emit(
              lastState.copyWith(
                productList: lastState.productList,
              ),
            );
          }
        }
      });
    } catch (e) {
      emit(HomeErrorState(e.toString()));
      print(e);
    }
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  log("----- error log --- ",error: "ngnkdfnkgkdf");

  _getCurrentLocation();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  _getCurrentLocation();
}

Future<void> _getCurrentLocation() async {
  try {
    log("----- error log --_getCurrentLocation- ",error: "ngnkdfnkgkdf");

    /// tested om android and its working fine
    /// but not working on ios
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
       }
    }

    location.enableBackgroundMode(enable: true);
    permissionGranted = await location.requestPermission();
    print("-----print----- permissionGranted  ${permissionGranted}");
    if (permissionGranted != PermissionStatus.granted) {
     }

    var position = await Geolocator.getCurrentPosition();
    var collection = FirebaseFirestore.instance.collection('location');
    collection.add(
      {
        "lat": position.latitude.toString(),
        "long": position.longitude.toString(),
        "current_date": ' ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
      },
    );
  } catch (e) {
    print("Error getting location: ${e.toString()}");
  }
  // Wait for 10 seconds before getting the location again
  await Future.delayed(const Duration(seconds: 10));
  await _getCurrentLocation();
}
