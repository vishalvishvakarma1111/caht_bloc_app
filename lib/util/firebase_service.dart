import 'dart:convert';
import 'package:chat_bloc_app/model/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../chat/chatview.dart';
import '../main.dart';
import 'notification_view.dart';

Future<void> _handler(RemoteMessage message) async {}

class FBNotification {
  FBNotification._();

  factory FBNotification() => _instance;
  static final FBNotification _instance = FBNotification._();

  Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getToken().then((token) {});

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          //notificationOperation(payload: message.data);
        });
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        var showNotification = peerChatUser?.uid != message.data['uid'];
        if (showNotification) {
          displayNotificationView(payload: message);
        }
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      selectNotification(jsonEncode(message.data));
    });

    FirebaseMessaging.onBackgroundMessage(_handler);
  }

  void displayNotificationView({required RemoteMessage payload, String? peerUid}) {
    RemoteNotification remoteNotification = payload.notification!;

    if (payload.data['uid'] != peerUid) {
      showOverlayNotification(
        (BuildContext context) {
          return NotificationView(
            title: remoteNotification.title ?? "",
            subTitle: remoteNotification.body ?? "",
            onTap: () {
              OverlaySupportEntry.of(context)?.dismiss();
              //  notificationOperation(payload: payload.data);
            },
          );
        },
      );
    }
  }

  Future<void> selectNotification(String? payload) async {
    if (payload != null) {
      Map<String, dynamic> json = jsonDecode(payload);
    }
  }
}
