import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class MyFirebaseUtil {
  static final MyFirebaseUtil _singleton = MyFirebaseUtil._internal();

  MyFirebaseUtil._internal();

  static MyFirebaseUtil get instance => _singleton;

  String getUid() => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<String> getName() async {
    final result = await FirebaseFirestore.instance.collection('user').where('uid', isEqualTo: getUid()).get();
    var map = result.docs.first.data();
    return map['name'];
  }

  Future<String?> getToken() async => kIsWeb
      ? await FirebaseMessaging.instance
          .getToken(vapidKey: 'BL95GBhLnTIyO7kY2JKGCwaBb-M_vJZJ5vhQrviVQY6eqo2kro2WGopiYfo9w42hBbQXkIgQLAmBzGx7---ikEY')
      : await FirebaseMessaging.instance.getToken();
}

const String categoryTable = 'category';
const String productTable = 'product';
const String cartTable = 'cart';
const String userTable = 'user';
const String addressTable = 'address';
const String orderTable = 'orders';
