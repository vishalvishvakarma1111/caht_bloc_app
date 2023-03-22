import 'dart:async';
import 'package:flutter/material.dart';
 import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

// import 'dart:ui';
//
import 'package:chat_bloc_app/home/bloc/home_bloc.dart';
import 'package:chat_bloc_app/home/homeview.dart';
import 'package:chat_bloc_app/model/userModel.dart';
import 'package:chat_bloc_app/shopping/addmin/category/add_cate_view.dart';
import 'package:chat_bloc_app/shopping/addmin/home_cate/catelist.dart';
import 'package:chat_bloc_app/shopping/dashbaord/dashbaord_view.dart';
import 'package:chat_bloc_app/shopping/home_shopping/home_shopping_view.dart';
import 'package:chat_bloc_app/src/widgets/day_view.dart';
import 'package:chat_bloc_app/src/widgets/item.dart';
import 'package:chat_bloc_app/util/firebase_service.dart';
import 'package:chat_bloc_app/util/preference_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

import 'file_upload/file_upload.dart';
import 'firebase_options.dart';
import 'login/login_view.dart';
import 'my_exports.dart';
import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';

bool isLogin = false;
UserModel? peerChatUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FBNotification().init();

  isLogin = await PreferenceHelper.instance().getPreference(PreferenceHelper.isLogin, PrefTypes.bool);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<HomeBloc>(
        create: (context) => HomeBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: MyView(),\
        // home: const CategoryListView(),
        // home: isLogin ? DashBoardView() : const LoginView(),
        // home: isLogin ? const HomeView() : const LoginView(),
        home: FileUploadBackground(),
        scaffoldMessengerKey: snackBarKey,
      ),
    );
  }
}

final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();

class MyView extends StatelessWidget {
  const MyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return Scaffold(
      appBar: AppBar(),
      body: DayView(
        initialTime: const HourMinute(hour: 7),
        date: DateTime.now(),
        hoursColumnStyle: const HoursColumnStyle(
          interval: Duration(minutes: 30),
          textStyle: TextStyle(fontSize: 11, color: Colors.black),
        ),
        events: [
          MyDayViewEvent(
            title: 'An event 1',
            description: 'A description 1',
            backgroundColor: Colors.white,
            eventTextBuilder:
                (MyDayViewEvent event, BuildContext context, DayView dayView, double height, double width) {
              return ItemView();
            },
            start: date.subtract(const Duration(hours: 1)),
            end: date.add(
              const Duration(
                hours: 1,
              ),
            ),
          ),
          MyDayViewEvent(
            title: 'An event 2',
            description: 'A description 2',
            backgroundColor: Colors.white,
            eventTextBuilder:
                (MyDayViewEvent event, BuildContext context, DayView dayView, double height, double width) {
              return ItemView();
            },
            start: date.subtract(const Duration(hours: 2)),
            end: date.add(
              const Duration(
                hours: 3,
              ),
            ),
          ),
        ],
        style: DayViewStyle.fromDate(
          date: date,
          hourRowHeight: 100,
          currentTimeCircleColor: Colors.pink,
        ),
      ),
    );
  }
}
